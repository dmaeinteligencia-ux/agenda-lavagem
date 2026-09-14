-- =============================================
-- Migration: Create solicitantes_lavagem
-- Date: 2026-09-10
-- Description: Creates the solicitantes_lavagem
-- table (requesters of washes without requiring
-- an authenticated user) and links it to
-- reservas_lavagem through a nullable
-- solicitante_id foreign key
-- =============================================

-- =============================================
-- 1. Table: solicitantes_lavagem
-- =============================================
CREATE TABLE solicitantes_lavagem (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  matricula TEXT NOT NULL UNIQUE,
  nome TEXT NOT NULL,
  telefone TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_solicitantes_lavagem
  BEFORE UPDATE ON solicitantes_lavagem
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 2. Add solicitante_id to reservas_lavagem
--     (nullable to keep existing reservations
--      created before this entity)
-- =============================================
ALTER TABLE reservas_lavagem
  ADD COLUMN solicitante_id UUID REFERENCES solicitantes_lavagem(id);

-- =============================================
-- 3. Index: solicitante_id
-- =============================================
CREATE INDEX idx_reservas_lavagem_solicitante_id
  ON reservas_lavagem(solicitante_id);
