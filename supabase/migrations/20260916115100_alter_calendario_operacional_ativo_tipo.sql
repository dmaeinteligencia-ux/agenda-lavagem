-- =============================================
-- Migration: calendario_operacional — atendimento e tipo de configuração
-- Date: 2026-09-16
-- Description:
--   Adiciona à configuração manual da data:
--     - ativo boolean NOT NULL DEFAULT true  (atendimento daquela DATA);
--     - tipo_configuracao text NOT NULL DEFAULT 'OUTRO'
--       (PONTO_FACULTATIVO | FERIADO | OUTRO) — classificação MANUAL,
--       distinta de public.feriados_oficiais.
--   Não altera policies/grants existentes.
-- =============================================

ALTER TABLE public.calendario_operacional
  ADD COLUMN ativo boolean NOT NULL DEFAULT true;

ALTER TABLE public.calendario_operacional
  ADD COLUMN tipo_configuracao text NOT NULL DEFAULT 'OUTRO';

ALTER TABLE public.calendario_operacional
  ADD CONSTRAINT calendario_operacional_tipo_configuracao_check
  CHECK (tipo_configuracao IN ('PONTO_FACULTATIVO', 'FERIADO', 'OUTRO'));
