-- =============================================
-- Migration: Bloquear reservas para veículos inativos
-- Date: 2026-09-16
-- Description:
--   1. buscar_veiculo_por_placa() passa a retornar ativo boolean
--      (não esconde o inativo; o frontend decide como informar).
--   2. criar_reserva_lavagem() passa a bloquear veículo inativo.
--   3. consultar_disponibilidade() passa a considerar ativo em
--      "disponivel" (sem mudar o shape). A wrapper pública herda.
-- Não altera tabelas, policies, grants existentes nem outras RPCs.
-- =============================================

-- =============================================
-- 1. buscar_veiculo_por_placa: adicionar ativo
-- =============================================
DROP FUNCTION public.buscar_veiculo_por_placa(text);

CREATE FUNCTION public.buscar_veiculo_por_placa(
  p_placa text
)
RETURNS TABLE (
  id uuid,
  nome_frota text,
  ds_modelo text,
  ds_combustivel text,
  ano integer,
  nr_placa_transport text,
  tipo_veiculo_id uuid,
  tipo_veiculo_descricao text,
  ativo boolean
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_placa text;
BEGIN
  v_placa := regexp_replace(upper(btrim(p_placa)), '[^A-Z0-9]', '', 'g');

  IF v_placa IS NULL OR v_placa = '' THEN
    RAISE EXCEPTION 'Placa inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a placa do veículo.';
  END IF;

  RETURN QUERY
  SELECT
    v.id,
    v.nome_frota,
    v.ds_modelo,
    v.ds_combustivel,
    v.ano,
    v.nr_placa_transport,
    v.tipo_veiculo_id,
    tvl.descricao,
    v.ativo
  FROM public.veiculos v
  LEFT JOIN public.tipos_veiculo_lavador tvl ON tvl.id = v.tipo_veiculo_id
  WHERE v.nr_placa_transport = v_placa
  LIMIT 1;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) TO anon, authenticated, service_role;

-- =============================================
-- 2. criar_reserva_lavagem: bloquear veículo inativo
-- =============================================
CREATE OR REPLACE FUNCTION public.criar_reserva_lavagem(
  p_solicitante_id uuid,
  p_veiculo_id uuid,
  p_data date,
  p_observacao text DEFAULT NULL
)
RETURNS TABLE (
  id uuid,
  solicitante_id uuid,
  veiculo_id uuid,
  data_reserva date,
  status text,
  tempo_estimado integer,
  observacao text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_tempo_min integer;
  v_regime text;
  v_capacidade_minutos integer;
  v_reservado_minutos integer;
  v_dow integer;
  v_observacao text;
  v_nova_reserva_id uuid;
BEGIN
  -- 1. Validações de entrada
  IF p_solicitante_id IS NULL THEN
    RAISE EXCEPTION 'Solicitante inválido.'
      USING ERRCODE = '22023', HINT = 'Informe o solicitante da reserva.';
  END IF;

  IF p_veiculo_id IS NULL THEN
    RAISE EXCEPTION 'Veículo inválido.'
      USING ERRCODE = '22023', HINT = 'Informe o veículo da reserva.';
  END IF;

  IF p_data IS NULL THEN
    RAISE EXCEPTION 'Data inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a data da reserva.';
  END IF;

  IF p_data < CURRENT_DATE THEN
    RAISE EXCEPTION 'Não é possível criar uma reserva para uma data passada.'
      USING
        ERRCODE = '22023',
        HINT = 'Informe a data de hoje ou uma data futura.';
  END IF;

  v_observacao := NULLIF(btrim(p_observacao), '');

  -- 2. Solicitante existe
  IF NOT EXISTS (
    SELECT 1 FROM public.solicitantes_lavagem s WHERE s.id = p_solicitante_id
  ) THEN
    RAISE EXCEPTION 'Solicitante não encontrado.'
      USING HINT = 'Verifique o identificador do solicitante.';
  END IF;

  -- 3. Veículo existe
  IF NOT EXISTS (
    SELECT 1 FROM public.veiculos v WHERE v.id = p_veiculo_id
  ) THEN
    RAISE EXCEPTION 'Veículo não encontrado.'
      USING HINT = 'Verifique o identificador do veículo.';
  END IF;

  -- 3.1 Veículo ativo (não permitir reserva para veículo inativo)
  IF NOT EXISTS (
    SELECT 1 FROM public.veiculos v WHERE v.id = p_veiculo_id AND v.ativo
  ) THEN
    RAISE EXCEPTION 'Não é possível criar reserva para um veículo inativo.'
      USING ERRCODE = '22023', HINT = 'Ative o veículo para criar novas reservas.';
  END IF;

  -- 4. Tipo configurado + tempo_min válido (valor a ser congelado)
  SELECT tvl.tempo_min
  INTO v_tempo_min
  FROM public.veiculos v
  JOIN public.tipos_veiculo_lavador tvl ON tvl.id = v.tipo_veiculo_id
  WHERE v.id = p_veiculo_id;

  IF v_tempo_min IS NULL OR v_tempo_min <= 0 THEN
    RAISE EXCEPTION 'Tipo do veículo não está configurado para lavagem.'
      USING HINT = 'Configure o tipo do veículo em tipos_veiculo_lavador.';
  END IF;

  -- 5. Regime da data (mesma regra de consultar_disponibilidade)
  SELECT co.regime
  INTO v_regime
  FROM public.calendario_operacional co
  WHERE co.data = p_data;

  IF v_regime IS NULL THEN
    v_dow := EXTRACT(DOW FROM p_data)::INT;

    IF v_dow BETWEEN 1 AND 5 THEN
      v_regime := 'NORMAL';
    ELSE
      v_regime := 'PLANTAO';
    END IF;
  END IF;

  -- 6. Capacidade da jornada do regime
  SELECT jl.horas_disponiveis * 60
  INTO v_capacidade_minutos
  FROM public.jornadas_lavador jl
  WHERE jl.regime = v_regime;

  IF v_capacidade_minutos IS NULL THEN
    RAISE EXCEPTION 'Jornada não configurada para o regime da data.'
      USING HINT = 'Configure a jornada para o regime ' || v_regime || ' em jornadas_lavador.';
  END IF;

  -- 7. Bloqueio transacional por data (namespace 1 = criação de reserva;
  --    mesma data → mesmo lock; datas diferentes → locks diferentes)
  PERFORM pg_advisory_xact_lock(
    1,
    (p_data - DATE '1970-01-01')::integer
  );

  -- 8. Capacidade consumida na data
  SELECT COALESCE(SUM(r.tempo_estimado), 0)
  INTO v_reservado_minutos
  FROM public.reservas_lavagem r
  WHERE r.data_reserva = p_data
    AND r.status IN ('RESERVADA', 'EM_LAVAGEM', 'CONCLUIDA', 'NAO_CONCLUIDA');

  IF v_capacidade_minutos - v_reservado_minutos < v_tempo_min THEN
    RAISE EXCEPTION 'Capacidade insuficiente para esta data.'
      USING HINT = 'A jornada do dia não comporta o tempo necessário para esta reserva.';
  END IF;

  -- 9. Duplicidade do veículo na data (validação amigável)
  IF EXISTS (
    SELECT 1 FROM public.reservas_lavagem r
    WHERE r.veiculo_id = p_veiculo_id
      AND r.data_reserva = p_data
      AND r.status IN ('RESERVADA', 'EM_LAVAGEM')
  ) THEN
    RAISE EXCEPTION 'O veículo já possui uma reserva ativa para esta data.'
      USING HINT = 'Este veículo já está reservado (RESERVADA ou EM_LAVAGEM) nesta data.';
  END IF;

  -- 10. INSERT da reserva (índice parcial como proteção final contra corrida)
  BEGIN
    INSERT INTO public.reservas_lavagem AS r (
      solicitante_id,
      veiculo_id,
      data_reserva,
      status,
      tempo_estimado,
      observacao
    )
    VALUES (
      p_solicitante_id,
      p_veiculo_id,
      p_data,
      'RESERVADA',
      v_tempo_min,
      v_observacao
    )
    RETURNING r.id INTO v_nova_reserva_id;
  EXCEPTION
    WHEN unique_violation THEN
      RAISE EXCEPTION 'O veículo já possui uma reserva ativa para esta data.'
        USING ERRCODE = '23505',
              HINT = 'Este veículo já está reservado (RESERVADA ou EM_LAVAGEM) nesta data.';
  END;

  -- 11. Auditoria (atômica com a reserva)
  INSERT INTO public.eventos_reserva (
    reserva_id,
    usuario_id,
    tipo_evento,
    status_anterior,
    status_novo,
    observacao
  )
  VALUES (
    v_nova_reserva_id,
    NULL,
    'CRIACAO',
    NULL,
    'RESERVADA',
    NULL
  );

  -- 12. Retorno
  RETURN QUERY
  SELECT
    r.id,
    r.solicitante_id,
    r.veiculo_id,
    r.data_reserva,
    r.status,
    r.tempo_estimado,
    r.observacao
  FROM public.reservas_lavagem r
  WHERE r.id = v_nova_reserva_id;

END;
$function$;

-- =============================================
-- 3. consultar_disponibilidade: considerar ativo em "disponivel"
-- =============================================
CREATE OR REPLACE FUNCTION public.consultar_disponibilidade(
  p_veiculo_id uuid,
  p_data date
)
RETURNS TABLE (
  data_reserva date,
  regime text,
  capacidade_minutos integer,
  reservado_minutos integer,
  disponivel_minutos integer,
  tempo_veiculo_minutos integer,
  veiculo_tem_reserva boolean,
  disponivel boolean
)
LANGUAGE plpgsql
STABLE
SET search_path TO ''
AS $function$
DECLARE
  v_tempo_min INTEGER;
  v_regime TEXT;
  v_capacidade_minutos INTEGER;
  v_reservado_minutos INTEGER;
  v_disponivel_minutos INTEGER;
  v_veiculo_tem_reserva BOOLEAN;
  v_veiculo_ativo BOOLEAN;
  v_disponivel BOOLEAN;
  v_dow INTEGER;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.veiculos WHERE id = p_veiculo_id) THEN
    RAISE EXCEPTION 'Veículo não encontrado.'
      USING HINT = 'Verifique o identificador do veículo.';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.veiculos
    WHERE id = p_veiculo_id AND tipo_veiculo_id IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Tipo do veículo não está configurado para lavagem.'
      USING HINT = 'Configure o tipo do veículo em tipos_veiculo_lavador.';
  END IF;

  SELECT tvl.tempo_min INTO v_tempo_min
  FROM public.veiculos v
  JOIN public.tipos_veiculo_lavador tvl ON v.tipo_veiculo_id = tvl.id
  WHERE v.id = p_veiculo_id;

  SELECT v.ativo INTO v_veiculo_ativo
  FROM public.veiculos v
  WHERE v.id = p_veiculo_id;

  SELECT co.regime INTO v_regime
  FROM public.calendario_operacional co
  WHERE co.data = p_data;

  IF v_regime IS NULL THEN
    v_dow := EXTRACT(DOW FROM p_data)::INT;

    IF v_dow BETWEEN 1 AND 5 THEN
      v_regime := 'NORMAL';
    ELSE
      v_regime := 'PLANTAO';
    END IF;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.jornadas_lavador jl WHERE jl.regime = v_regime
  ) THEN
    RAISE EXCEPTION 'Jornada não configurada para o regime da data.'
      USING HINT = 'Configure a jornada para o regime ' || v_regime || ' em jornadas_lavador.';
  END IF;

  SELECT jl.horas_disponiveis * 60 INTO v_capacidade_minutos
  FROM public.jornadas_lavador jl
  WHERE jl.regime = v_regime;

  SELECT COALESCE(SUM(rl.tempo_estimado), 0) INTO v_reservado_minutos
  FROM public.reservas_lavagem rl
  WHERE rl.data_reserva = p_data
    AND rl.status IN ('RESERVADA', 'EM_LAVAGEM', 'CONCLUIDA', 'NAO_CONCLUIDA');

  v_disponivel_minutos := GREATEST(v_capacidade_minutos - v_reservado_minutos, 0);

  SELECT EXISTS (
    SELECT 1 FROM public.reservas_lavagem rl
    WHERE rl.veiculo_id = p_veiculo_id
      AND rl.data_reserva = p_data
      AND rl.status IN ('RESERVADA', 'EM_LAVAGEM')
  ) INTO v_veiculo_tem_reserva;

  v_disponivel := (
    v_veiculo_ativo
    AND v_disponivel_minutos >= v_tempo_min
    AND NOT v_veiculo_tem_reserva
  );

  RETURN QUERY
  SELECT
    p_data,
    v_regime,
    v_capacidade_minutos,
    v_reservado_minutos,
    v_disponivel_minutos,
    v_tempo_min,
    v_veiculo_tem_reserva,
    v_disponivel;

END;
$function$;
