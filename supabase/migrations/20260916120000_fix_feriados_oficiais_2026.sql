-- =============================================
-- Migration: Corrige feriados oficiais de 2026 (Uberlândia)
-- Date: 2026-09-16
-- Description:
--   Corrige a classificação/carga de feriados de 2026 conforme o
--   Calendário Oficial de Feriados e Pontos Facultativos de Uberlândia
--   2026 (Decreto Municipal nº 22.174, de 06/10/2025):
--     - Paixão de Cristo (03/04): reclassificada de NACIONAL -> MUNICIPAL;
--     - Corpus Christi (04/06): incluída como MUNICIPAL;
--     - Nossa Senhora da Abadia (15/08): incluída como MUNICIPAL;
--     - São Raimundo / Aniversário de Uberlândia (31/08): nome/fonte.
--   Garante que pontos facultativos NÃO estejam na base automática.
--   Não altera resolver_dia_operacional nem regras de reservas.
-- =============================================

-- 1. Paixão de Cristo -> MUNICIPAL (Uberlândia)
UPDATE public.feriados_oficiais
SET nome = 'Paixão de Cristo',
    abrangencia = 'MUNICIPAL',
    uf = 'MG',
    municipio = 'Uberlândia',
    fonte = 'Decreto Municipal nº 22.174, de 06/10/2025 (Calendário Oficial de Uberlândia 2026)'
WHERE data = DATE '2026-04-03'
  AND nome = 'Sexta-feira Santa (Paixão de Cristo)';

-- 2. Aniversário de Uberlândia -> nome/fonte oficiais
UPDATE public.feriados_oficiais
SET nome = 'São Raimundo / Aniversário de Uberlândia',
    uf = 'MG',
    municipio = 'Uberlândia',
    fonte = 'Decreto Municipal nº 22.174, de 06/10/2025 (Calendário Oficial de Uberlândia 2026)'
WHERE data = DATE '2026-08-31'
  AND nome = 'Aniversário de Uberlândia';

-- 3. Municipais faltantes
INSERT INTO public.feriados_oficiais (data, nome, abrangencia, uf, municipio, fonte) VALUES
  ('2026-06-04', 'Corpus Christi', 'MUNICIPAL', 'MG', 'Uberlândia', 'Decreto Municipal nº 22.174, de 06/10/2025 (Calendário Oficial de Uberlândia 2026)'),
  ('2026-08-15', 'Nossa Senhora da Abadia', 'MUNICIPAL', 'MG', 'Uberlândia', 'Decreto Municipal nº 22.174, de 06/10/2025 (Calendário Oficial de Uberlândia 2026)')
ON CONFLICT (data, nome) DO NOTHING;

-- 4. Garantia: pontos facultativos não pertencem à base automática
DELETE FROM public.feriados_oficiais
WHERE data IN (
  DATE '2026-02-16', -- Carnaval
  DATE '2026-02-17', -- Carnaval
  DATE '2026-02-18', -- Quarta-feira de Cinzas
  DATE '2026-04-02', -- Quinta-feira Santa
  DATE '2026-07-16', -- Nossa Senhora do Carmo
  DATE '2026-10-30'  -- Dia do Servidor Público
);
