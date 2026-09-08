-- =============================================
-- Migration: Create Lavador Schema
-- Date: 2026-08-26
-- Description: Initial schema for the DMAE fleet
-- washing management system (Agenda de Lavagem)
-- =============================================

-- =============================================
-- 1. Function: update_updated_at_column
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- =============================================
-- 2. Table: perfis_usuarios
-- =============================================
CREATE TABLE perfis_usuarios (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  perfil TEXT NOT NULL CHECK (
    perfil IN (
      'ADMIN',
      'GESTAO_FROTA',
      'LAVADOR',
      'MOTORISTA'
    )
  ),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_perfis_usuarios
  BEFORE UPDATE ON perfis_usuarios
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 3. Table: tipos_veiculo_lavador
-- =============================================
CREATE TABLE tipos_veiculo_lavador (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  descricao TEXT NOT NULL UNIQUE,
  tempo_min INTEGER NOT NULL CHECK (tempo_min > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_tipos_veiculo_lavador
  BEFORE UPDATE ON tipos_veiculo_lavador
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 4. Table: veiculos
-- =============================================
CREATE TABLE veiculos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cd_equipamento INTEGER NOT NULL UNIQUE,
  ds_marca TEXT,
  dt_ano_fabricacao INTEGER,
  ds_modelo TEXT,
  ds_combustivel TEXT,
  nr_placa_transport TEXT,
  ds_cor TEXT,
  dt_aquisicao DATE,
  dt_ano_modelo INTEGER,
  nr_capac_hodometro NUMERIC,
  id_classifica_frota TEXT,
  nr_frota INTEGER,
  tipo_veiculo_id UUID REFERENCES tipos_veiculo_lavador(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_veiculos
  BEFORE UPDATE ON veiculos
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 5. Table: jornadas_lavador
-- =============================================
CREATE TABLE jornadas_lavador (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  regime TEXT NOT NULL CHECK (
    regime IN ('NORMAL', 'PLANTAO')
  ),
  horas_disponiveis INTEGER NOT NULL CHECK (horas_disponiveis > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX idx_jornadas_lavador_regime ON jornadas_lavador(regime);

CREATE TRIGGER set_updated_at_jornadas_lavador
  BEFORE UPDATE ON jornadas_lavador
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 6. Table: calendario_operacional
-- =============================================
CREATE TABLE calendario_operacional (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  data DATE NOT NULL UNIQUE,
  regime TEXT NOT NULL CHECK (
    regime IN ('NORMAL', 'PLANTAO')
  ),
  observacao TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_calendario_operacional
  BEFORE UPDATE ON calendario_operacional
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 7. Table: reservas_lavagem
-- =============================================
CREATE TABLE reservas_lavagem (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  veiculo_id UUID NOT NULL REFERENCES veiculos(id),
  data_reserva DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'RESERVADA' CHECK (
    status IN (
      'RESERVADA',
      'EM_LAVAGEM',
      'CONCLUIDA',
      'CANCELADA',
      'EXPIRADA'
    )
  ),
  tempo_estimado INTEGER NOT NULL CHECK (tempo_estimado > 0),
  observacao TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_reservas_lavagem
  BEFORE UPDATE ON reservas_lavagem
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 8. Table: eventos_reserva
-- =============================================
CREATE TABLE eventos_reserva (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reserva_id UUID NOT NULL REFERENCES reservas_lavagem(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  status_anterior TEXT NOT NULL CHECK (
    status_anterior IN (
      'RESERVADA',
      'EM_LAVAGEM',
      'CONCLUIDA',
      'CANCELADA',
      'EXPIRADA'
    )
  ),
  status_novo TEXT NOT NULL CHECK (
    status_novo IN (
      'RESERVADA',
      'EM_LAVAGEM',
      'CONCLUIDA',
      'CANCELADA',
      'EXPIRADA'
    )
  ),
  observacao TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =============================================
-- 9. Indexes
-- =============================================
CREATE INDEX idx_veiculos_nr_placa_transport ON veiculos(nr_placa_transport);

CREATE INDEX idx_reservas_lavagem_veiculo_id ON reservas_lavagem(veiculo_id);
CREATE INDEX idx_reservas_lavagem_data_reserva ON reservas_lavagem(data_reserva);
CREATE INDEX idx_reservas_lavagem_status ON reservas_lavagem(status);

CREATE INDEX idx_eventos_reserva_reserva_id ON eventos_reserva(reserva_id);

-- =============================================
-- 10. Partial Unique Index: reservas_lavagem
--     Blocks only RESERVADA or EM_LAVAGEM
-- =============================================
CREATE UNIQUE INDEX idx_reservas_lavagem_unique_active
  ON reservas_lavagem(veiculo_id, data_reserva)
  WHERE status IN ('RESERVADA', 'EM_LAVAGEM');