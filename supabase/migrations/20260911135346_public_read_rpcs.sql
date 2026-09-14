-- =============================================
-- Migration: Public read-only RPCs for /nova-reserva
-- Date: 2026-09-11
-- Description: Create three controlled public RPCs
-- used by the public reservation flow:
--   1. buscar_solicitante_por_matricula()
--   2. buscar_veiculo_por_placa()
--   3. consultar_disponibilidade_publica()
-- All are SECURITY DEFINER with safe search_path,
-- qualified table references, exact lookups and
-- minimal return columns. No direct table access
-- is granted to anon.
-- =============================================

-- =============================================
-- 1. buscar_solicitante_por_matricula(text)
-- =============================================
CREATE OR REPLACE FUNCTION public.buscar_solicitante_por_matricula(
  p_matricula text
)
RETURNS TABLE (
  id uuid,
  matricula text,
  nome text
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF p_matricula IS NULL OR btrim(p_matricula) = '' THEN
    RAISE EXCEPTION 'Matrícula inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a matrícula do solicitante.';
  END IF;

  RETURN QUERY
  SELECT s.id, s.matricula, s.nome
  FROM public.solicitantes_lavagem s
  WHERE s.matricula = btrim(p_matricula)
  LIMIT 1;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.buscar_solicitante_por_matricula(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.buscar_solicitante_por_matricula(text) TO anon, authenticated, service_role;

-- =============================================
-- 2. buscar_veiculo_por_placa(text)
-- =============================================
CREATE OR REPLACE FUNCTION public.buscar_veiculo_por_placa(
  p_placa text
)
RETURNS TABLE (
  id uuid,
  nr_placa_transport text,
  ds_marca text,
  ds_modelo text,
  id_classifica_frota text,
  nr_frota integer,
  tipo_veiculo_id uuid
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF p_placa IS NULL OR btrim(p_placa) = '' THEN
    RAISE EXCEPTION 'Placa inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a placa do veículo.';
  END IF;

  RETURN QUERY
  SELECT
    v.id,
    v.nr_placa_transport,
    v.ds_marca,
    v.ds_modelo,
    v.id_classifica_frota,
    v.nr_frota,
    v.tipo_veiculo_id
  FROM public.veiculos v
  WHERE upper(v.nr_placa_transport) = upper(btrim(p_placa))
  LIMIT 1;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) TO anon, authenticated, service_role;

-- =============================================
-- 3. consultar_disponibilidade_publica(uuid, date)
--    Wrapper around the internal (authenticated)
--    consultar_disponibilidade(), safe for anon.
-- =============================================
CREATE OR REPLACE FUNCTION public.consultar_disponibilidade_publica(
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
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF p_veiculo_id IS NULL THEN
    RAISE EXCEPTION 'Veículo inválido.'
      USING ERRCODE = '22023', HINT = 'Informe o identificador do veículo.';
  END IF;

  IF p_data IS NULL THEN
    RAISE EXCEPTION 'Data inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a data da reserva.';
  END IF;

  RETURN QUERY
  SELECT
    c.data_reserva,
    c.regime,
    c.capacidade_minutos,
    c.reservado_minutos,
    c.disponivel_minutos,
    c.tempo_veiculo_minutos,
    c.veiculo_tem_reserva,
    c.disponivel
  FROM public.consultar_disponibilidade(p_veiculo_id, p_data) c;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade_publica(uuid, date) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade_publica(uuid, date) TO anon, authenticated, service_role;
