-- =============================================
-- Migration: Ampliar buscar_veiculo_por_placa()
-- Date: 2026-09-15
-- Description: Adiciona o retorno tipo_veiculo_descricao
-- (descrição amigável do tipo) via LEFT JOIN com
-- public.tipos_veiculo_lavador, sem abrir acesso direto
-- anon às tabelas. Preserva SECURITY DEFINER, search_path,
-- normalização da placa e os grants públicos existentes.
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
  tipo_veiculo_descricao text
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
    tvl.descricao
  FROM public.veiculos v
  LEFT JOIN public.tipos_veiculo_lavador tvl ON tvl.id = v.tipo_veiculo_id
  WHERE v.nr_placa_transport = v_placa
  LIMIT 1;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) TO anon, authenticated, service_role;
