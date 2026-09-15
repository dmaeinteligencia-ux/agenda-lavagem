-- =============================================
-- Migration: Create public.criar_reserva_lavagem()
-- Date: 2026-09-14
-- Description: Public RPC for /nova-reserva. Creates a
-- RESERVADA reservation with tempo_estimado frozen from
-- the vehicle's type, validates capacity and vehicle
-- availability, serializes concurrent creations per date
-- via a transactional advisory lock, and writes a CRIACAO
-- audit event atomically with the reservation.
--
-- Does NOT change table structure, RLS, policies or table
-- grants. The partial unique index
-- idx_reservas_lavagem_unique_active is kept as the final
-- concurrency safeguard.
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
    AND r.status IN ('RESERVADA', 'EM_LAVAGEM', 'CONCLUIDA');

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

-- =============================================
-- Grants
-- =============================================
REVOKE EXECUTE ON FUNCTION public.criar_reserva_lavagem(uuid, uuid, date, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.criar_reserva_lavagem(uuid, uuid, date, text) TO anon, authenticated, service_role;
