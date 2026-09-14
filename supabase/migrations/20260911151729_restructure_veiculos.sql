-- =============================================
-- Migration: Restructure public.veiculos
-- Date: 2026-09-11
-- Description: Align public.veiculos with the real
-- vehicle base received from DMAE.
--   - Remove legacy columns
--   - Add nome_frota / ano
--   - Make nr_placa_transport NOT NULL UNIQUE
--   - Update buscar_veiculo_por_placa()
-- Table is empty; no data migration needed.
-- =============================================

-- =============================================
-- 1. Drop the dependent function (return type
--    changes, so it must be recreated).
-- =============================================
DROP FUNCTION public.buscar_veiculo_por_placa(text);

-- =============================================
-- 2. Remove obsolete columns
-- =============================================
ALTER TABLE public.veiculos
  DROP COLUMN cd_equipamento,
  DROP COLUMN ds_marca,
  DROP COLUMN dt_ano_fabricacao,
  DROP COLUMN ds_cor,
  DROP COLUMN dt_aquisicao,
  DROP COLUMN dt_ano_modelo,
  DROP COLUMN nr_capac_hodometro,
  DROP COLUMN id_classifica_frota,
  DROP COLUMN nr_frota;

-- =============================================
-- 3. Add new columns
-- =============================================
ALTER TABLE public.veiculos ADD COLUMN nome_frota TEXT;
ALTER TABLE public.veiculos ADD COLUMN ano INTEGER;

-- =============================================
-- 4. Make nr_placa_transport NOT NULL UNIQUE
--    (drop the redundant non-unique index)
-- =============================================
DROP INDEX IF EXISTS public.idx_veiculos_nr_placa_transport;

ALTER TABLE public.veiculos
  ALTER COLUMN nr_placa_transport SET NOT NULL;

ALTER TABLE public.veiculos
  ADD CONSTRAINT veiculos_nr_placa_transport_key
  UNIQUE (nr_placa_transport);

ALTER TABLE public.veiculos
  ADD CONSTRAINT veiculos_nr_placa_transport_formato_check
  CHECK (nr_placa_transport ~ '^[A-Z0-9]+$');

-- =============================================
-- 5. Recreate buscar_veiculo_por_placa(text)
-- =============================================
CREATE OR REPLACE FUNCTION public.buscar_veiculo_por_placa(
  p_placa text
)
RETURNS TABLE (
  id uuid,
  nome_frota text,
  ds_modelo text,
  ds_combustivel text,
  ano integer,
  nr_placa_transport text,
  tipo_veiculo_id uuid
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
    v.tipo_veiculo_id
  FROM public.veiculos v
  WHERE v.nr_placa_transport = v_placa
  LIMIT 1;
END;
$$;

-- =============================================
-- 6. Reestablish grants
-- =============================================
REVOKE EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.buscar_veiculo_por_placa(text) TO anon, authenticated, service_role;
