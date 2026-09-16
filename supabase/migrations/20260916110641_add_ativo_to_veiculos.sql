-- =============================================
-- Migration: Adicionar ativo a public.veiculos
-- Date: 2026-09-16
-- Description: Adiciona a coluna ativo (boolean NOT NULL DEFAULT true)
-- para suportar inativação sem exclusão física. Veículos existentes
-- permanecem ativos e novos veículos nascem ativos.
-- Não altera RLS, policies, grants, FKs, constraints existentes
-- nem RPCs.
-- =============================================

ALTER TABLE public.veiculos
ADD COLUMN ativo boolean NOT NULL DEFAULT true;
