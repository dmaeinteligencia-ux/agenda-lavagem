-- =============================================
-- Migration: Improve eventos_reserva
-- Date: 2026-08-26
-- Description: Adds tipo_evento column and makes
-- status_anterior nullable to support CRIACAO events
-- =============================================

-- =============================================
-- 1. Add tipo_evento column
-- =============================================
ALTER TABLE eventos_reserva
  ADD COLUMN tipo_evento TEXT NOT NULL CHECK (
    tipo_evento IN (
      'CRIACAO',
      'ALTERACAO_STATUS',
      'CANCELAMENTO',
      'EXPIRACAO'
    )
  );

-- =============================================
-- 2. Make status_anterior nullable
--     (supports CRIACAO events where
--      status_anterior = NULL)
-- =============================================
ALTER TABLE eventos_reserva
  ALTER COLUMN status_anterior DROP NOT NULL;