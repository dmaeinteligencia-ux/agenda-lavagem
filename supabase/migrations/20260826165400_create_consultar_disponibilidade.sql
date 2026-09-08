-- =============================================
-- Migration: Create consultar_disponibilidade RPC
-- Date: 2026-08-26
-- Description: Read-only function to check wash
-- availability for a vehicle on a given date
-- =============================================

CREATE OR REPLACE FUNCTION consultar_disponibilidade(
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
  -- =============================================
  -- 1. Validate vehicle exists
  -- =============================================
  IF NOT EXISTS (SELECT 1 FROM veiculos WHERE id = p_veiculo_id) THEN
    RAISE EXCEPTION 'Veículo não encontrado.'
      USING HINT = 'Verifique o identificador do veículo.';
  END IF;

  -- =============================================
  -- 2. Validate vehicle has tipo_veiculo_id
  -- =============================================
  IF NOT EXISTS (
    SELECT 1 FROM veiculos
    WHERE id = p_veiculo_id AND tipo_veiculo_id IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Tipo do veículo não está configurado para lavagem.'
      USING HINT = 'Configure o tipo do veículo em tipos_veiculo_lavador.';
  END IF;

  -- =============================================
  -- 3. Get tempo_min from tipos_veiculo_lavador
  -- =============================================
  SELECT tvl.tempo_min INTO v_tempo_min
  FROM veiculos v
  JOIN tipos_veiculo_lavador tvl ON v.tipo_veiculo_id = tvl.id
  WHERE v.id = p_veiculo_id;

  -- =============================================
  -- 4. Determine regime for the date
  -- =============================================
  SELECT co.regime INTO v_regime
  FROM calendario_operacional co
  WHERE co.data = p_data;

  IF v_regime IS NULL THEN
    -- Fallback: day-of-week rule
    v_dow := EXTRACT(DOW FROM p_data)::INT;

    IF v_dow BETWEEN 1 AND 5 THEN
      v_regime := 'NORMAL';
    ELSE
      v_regime := 'PLANTAO';
    END IF;
  END IF;

  -- =============================================
  -- 5. Validate jornadas_lavador for the regime
  -- =============================================
  IF NOT EXISTS (
    SELECT 1 FROM jornadas_lavador WHERE regime = v_regime
  ) THEN
    RAISE EXCEPTION 'Jornada não configurada para o regime da data.'
      USING HINT = 'Configure a jornada para o regime ' || v_regime || ' em jornadas_lavador.';
  END IF;

  -- =============================================
  -- 6. Convert hours to minutes (capacity)
  -- =============================================
  SELECT jl.horas_disponiveis * 60 INTO v_capacidade_minutos
  FROM jornadas_lavador jl
  WHERE jl.regime = v_regime;

  -- =============================================
  -- 7. Sum reserved minutes for ALL vehicles on
  --    p_data (lavador total capacity consumed)
  -- =============================================
  SELECT COALESCE(SUM(rl.tempo_estimado), 0) INTO v_reservado_minutos
  FROM reservas_lavagem rl
  WHERE rl.data_reserva = p_data
    AND rl.status IN ('RESERVADA', 'EM_LAVAGEM', 'CONCLUIDA');

  -- =============================================
  -- 8. Calculate available minutes (min 0)
  -- =============================================
  v_disponivel_minutos := GREATEST(v_capacidade_minutos - v_reservado_minutos, 0);

  -- =============================================
  -- 9. Check for blocking reservation for the
  --    specific vehicle being consulted
  -- =============================================
  SELECT EXISTS (
    SELECT 1 FROM reservas_lavagem rl
    WHERE rl.veiculo_id = p_veiculo_id
      AND rl.data_reserva = p_data
      AND rl.status IN ('RESERVADA', 'EM_LAVAGEM')
  ) INTO v_veiculo_tem_reserva;

  -- =============================================
  -- 10. Calculate disponivel
  -- =============================================
  v_disponivel := (
    v_disponivel_minutos >= v_tempo_min
    AND NOT v_veiculo_tem_reserva
  );

  -- =============================================
  -- Return result
  -- =============================================
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