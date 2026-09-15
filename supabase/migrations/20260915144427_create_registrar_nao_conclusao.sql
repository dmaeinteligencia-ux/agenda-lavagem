-- =============================================
-- Migration: registrar_nao_conclusao + capacidade
-- Date: 2026-09-15
-- Description: RPC de não conclusão de lavagem (EM_LAVAGEM
-- -> NAO_CONCLUIDA) para usuários ativos ADMIN/LAVADOR, com
-- motivo estruturado, lock de linha e auditoria atômica.
--
-- NAO_CONCLUIDA DEVE continuar consumindo capacidade.
-- Atualiza a lista de status que consomem capacidade em:
--   - consultar_disponibilidade()
--   - criar_reserva_lavagem()
-- para incluir NAO_CONCLUIDA.
--
-- NÃO altera CHECK constraints, tabelas, RLS, policies,
-- grants de tabela ou outras regras dessas funções.
-- =============================================

-- =============================================
-- 1. registrar_nao_conclusao()
-- =============================================
CREATE OR REPLACE FUNCTION public.registrar_nao_conclusao(
  p_reserva_id uuid,
  p_motivo text,
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
SET search_path = ''
AS $$
DECLARE
  v_status_atual text;
  v_motivo text;
  v_observacao text;
BEGIN
  -- 1. Autorização (ADMIN ou LAVADOR, ambos ATIVOS)
  IF NOT (
    public.current_user_tem_acesso()
    AND public.current_user_perfil() IN ('ADMIN', 'LAVADOR')
  ) THEN
    RAISE EXCEPTION 'Acesso não autorizado.'
      USING HINT = 'Esta operação é permitida apenas para administradores e lavadores ativos.';
  END IF;

  -- 2. Validação de entrada
  IF p_reserva_id IS NULL THEN
    RAISE EXCEPTION 'Reserva inválida.'
      USING ERRCODE = '22023', HINT = 'Informe o identificador da reserva.';
  END IF;

  -- 3. Validação do motivo
  IF p_motivo IS NULL OR btrim(p_motivo) = '' THEN
    RAISE EXCEPTION 'Motivo obrigatório.'
      USING ERRCODE = '22023', HINT = 'Informe o motivo da não conclusão.';
  END IF;

  v_motivo := upper(btrim(p_motivo));

  IF v_motivo NOT IN (
    'FIM_DA_JORNADA',
    'INDISPONIBILIDADE_LAVADOR',
    'FALTA_AGUA',
    'FALHA_EQUIPAMENTO',
    'PROBLEMA_ESTRUTURAL',
    'PRIORIDADE_OPERACIONAL',
    'OUTRO'
  ) THEN
    RAISE EXCEPTION 'Motivo de não conclusão inválido.'
      USING ERRCODE = '22023';
  END IF;

  v_observacao := NULLIF(btrim(p_observacao), '');

  IF v_motivo = 'OUTRO' AND v_observacao IS NULL THEN
    RAISE EXCEPTION 'A observação é obrigatória quando o motivo informado é OUTRO.'
      USING ERRCODE = '22023';
  END IF;

  -- 4. Lock de linha (proteção contra concorrência na mesma reserva)
  SELECT r.status
  INTO v_status_atual
  FROM public.reservas_lavagem r
  WHERE r.id = p_reserva_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Reserva não encontrada.'
      USING HINT = 'Verifique o identificador da reserva.';
  END IF;

  -- 5. Transição permitida: somente EM_LAVAGEM -> NAO_CONCLUIDA
  IF v_status_atual <> 'EM_LAVAGEM' THEN
    RAISE EXCEPTION 'A lavagem não pode ser marcada como não concluída no status atual.'
      USING HINT = 'Somente reservas com status EM_LAVAGEM podem ser classificadas como não concluídas.';
  END IF;

  -- 6. Registro de não conclusão
  UPDATE public.reservas_lavagem r
  SET status = 'NAO_CONCLUIDA'
  WHERE r.id = p_reserva_id;

  -- 7. Auditoria (atômica com o registro)
  INSERT INTO public.eventos_reserva (
    reserva_id,
    usuario_id,
    tipo_evento,
    status_anterior,
    status_novo,
    motivo,
    observacao
  )
  VALUES (
    p_reserva_id,
    auth.uid(),
    'NAO_CONCLUSAO',
    'EM_LAVAGEM',
    'NAO_CONCLUIDA',
    v_motivo,
    v_observacao
  );

  -- 8. Retorno
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
  WHERE r.id = p_reserva_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.registrar_nao_conclusao(uuid, text, text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.registrar_nao_conclusao(uuid, text, text) FROM anon;
REVOKE EXECUTE ON FUNCTION public.registrar_nao_conclusao(uuid, text, text) FROM service_role;
GRANT EXECUTE ON FUNCTION public.registrar_nao_conclusao(uuid, text, text) TO authenticated;

-- =============================================
-- 2. consultar_disponibilidade() — incluir NAO_CONCLUIDA
--    na lista de status que consomem capacidade
-- =============================================
CREATE OR REPLACE FUNCTION public.consultar_disponibilidade(
  p_veiculo_id UUID,
  p_data DATE
)
RETURNS TABLE (
  data_reserva DATE,
  regime TEXT,
  capacidade_minutos INTEGER,
  reservado_minutos INTEGER,
  disponivel_minutos INTEGER,
  tempo_veiculo_minutos INTEGER,
  veiculo_tem_reserva BOOLEAN,
  disponivel BOOLEAN
)
LANGUAGE plpgsql
STABLE
SET search_path = ''
AS $$
DECLARE
  v_tempo_min INTEGER;
  v_regime TEXT;
  v_capacidade_minutos INTEGER;
  v_reservado_minutos INTEGER;
  v_disponivel_minutos INTEGER;
  v_veiculo_tem_reserva BOOLEAN;
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
    v_disponivel_minutos >= v_tempo_min
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
$$;

REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) FROM anon;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO authenticated;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO service_role;

-- =============================================
-- 3. criar_reserva_lavagem() — incluir NAO_CONCLUIDA
--    na lista de status que consomem capacidade
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
SET search_path = ''
AS $$
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
$$;

REVOKE EXECUTE ON FUNCTION public.criar_reserva_lavagem(uuid, uuid, date, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.criar_reserva_lavagem(uuid, uuid, date, text) TO anon, authenticated, service_role;
