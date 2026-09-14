-- =============================================
-- Migration: Fix consultar_disponibilidade ambiguous
--            column reference
-- Date: 2026-09-11
-- Description: Correct the ambiguous "regime" column
-- reference in public.consultar_disponibilidade().
--
-- The function uses RETURNS TABLE (... regime text ...),
-- so "regime" also exists as a PL/pgSQL OUT variable,
-- making the unqualified "regime" in the jornadas_lavador
-- lookup ambiguous (SQLSTATE 42702).
--
-- Only the ambiguous reference is changed:
--
--   FROM public.jornadas_lavador
--   WHERE regime = v_regime
--
-- becomes:
--
--   FROM public.jornadas_lavador jl
--   WHERE jl.regime = v_regime
--
-- Nothing else is altered: signature, RETURNS TABLE,
-- LANGUAGE, STABILITY, SECURITY INVOKER, search_path,
-- business rules, messages and grants are preserved.
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
    AND rl.status IN ('RESERVADA', 'EM_LAVAGEM', 'CONCLUIDA');

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

-- =============================================
-- Preserve grants (unchanged)
-- =============================================
REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) FROM anon;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO authenticated;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO service_role;
