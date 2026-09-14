-- =============================================
-- Migration: Security / Row Level Security
-- Date: 2026-09-11
-- Description: First security layer for the Lavador
-- fleet management system:
--   1. Bootstrap the existing ADMIN user
--   2. Remove MOTORISTA from allowed profiles
--   3. Create current_user_perfil() helper
--   4. Enable RLS on all domain tables
--   5. Create per-profile policies
--   6. Tighten grants for anon / authenticated
--   7. Harden consultar_disponibilidade()
--   8. Reduce update_updated_at_column() exposure
-- =============================================

-- =============================================
-- 1. Bootstrap the current administrator
--    (id confirmed from auth.users inspection)
-- =============================================
INSERT INTO public.perfis_usuarios (id, perfil)
SELECT id, 'ADMIN'
FROM auth.users
WHERE id = '22765ceb-6d7d-4532-8612-2de955c35628'::uuid
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- 2. Replace the perfil CHECK constraint
--    (drop MOTORISTA, keep TEXT, no enum)
-- =============================================
ALTER TABLE public.perfis_usuarios
  DROP CONSTRAINT perfis_usuarios_perfil_check;

ALTER TABLE public.perfis_usuarios
  ADD CONSTRAINT perfis_usuarios_perfil_check
  CHECK (perfil IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

-- =============================================
-- 3. Profile helper: public.current_user_perfil()
--    SECURITY DEFINER owned by postgres (BYPASSRLS)
--    avoids RLS recursion; returns NULL for anon.
-- =============================================
CREATE OR REPLACE FUNCTION public.current_user_perfil()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT p.perfil
  FROM public.perfis_usuarios p
  WHERE p.id = auth.uid();
$$;

REVOKE EXECUTE ON FUNCTION public.current_user_perfil() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.current_user_perfil() TO authenticated;

-- =============================================
-- 4. Enable Row Level Security (no FORCE)
-- =============================================
ALTER TABLE public.perfis_usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tipos_veiculo_lavador ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.veiculos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jornadas_lavador ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calendario_operacional ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas_lavagem ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eventos_reserva ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.solicitantes_lavagem ENABLE ROW LEVEL SECURITY;

-- =============================================
-- 5. Policies
-- =============================================

-- ---------------------------------------------
-- 5.1 perfis_usuarios
--     ADMIN: full access
--     GESTAO_FROTA / LAVADOR: read own profile only
-- ---------------------------------------------
CREATE POLICY perfis_usuarios_select_admin
  ON public.perfis_usuarios
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() = 'ADMIN');

CREATE POLICY perfis_usuarios_select_own
  ON public.perfis_usuarios
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY perfis_usuarios_insert_admin
  ON public.perfis_usuarios
  FOR INSERT
  TO authenticated
  WITH CHECK (public.current_user_perfil() = 'ADMIN');

CREATE POLICY perfis_usuarios_update_admin
  ON public.perfis_usuarios
  FOR UPDATE
  TO authenticated
  USING (public.current_user_perfil() = 'ADMIN')
  WITH CHECK (public.current_user_perfil() = 'ADMIN');

CREATE POLICY perfis_usuarios_delete_admin
  ON public.perfis_usuarios
  FOR DELETE
  TO authenticated
  USING (public.current_user_perfil() = 'ADMIN');

-- ---------------------------------------------
-- 5.2 solicitantes_lavagem
--     ADMIN: CRUD
--     GESTAO_FROTA: SELECT/INSERT/UPDATE
--     LAVADOR: SELECT
-- ---------------------------------------------
CREATE POLICY solicitantes_lavagem_select
  ON public.solicitantes_lavagem
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

CREATE POLICY solicitantes_lavagem_insert
  ON public.solicitantes_lavagem
  FOR INSERT
  TO authenticated
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY solicitantes_lavagem_update
  ON public.solicitantes_lavagem
  FOR UPDATE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'))
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY solicitantes_lavagem_delete
  ON public.solicitantes_lavagem
  FOR DELETE
  TO authenticated
  USING (public.current_user_perfil() = 'ADMIN');

-- ---------------------------------------------
-- 5.3 veiculos
--     ADMIN: CRUD
--     GESTAO_FROTA: SELECT/INSERT/UPDATE
--     LAVADOR: SELECT
-- ---------------------------------------------
CREATE POLICY veiculos_select
  ON public.veiculos
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

CREATE POLICY veiculos_insert
  ON public.veiculos
  FOR INSERT
  TO authenticated
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY veiculos_update
  ON public.veiculos
  FOR UPDATE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'))
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY veiculos_delete
  ON public.veiculos
  FOR DELETE
  TO authenticated
  USING (public.current_user_perfil() = 'ADMIN');

-- ---------------------------------------------
-- 5.4 tipos_veiculo_lavador
--     ADMIN: CRUD
--     GESTAO_FROTA: CRUD
--     LAVADOR: SELECT
-- ---------------------------------------------
CREATE POLICY tipos_veiculo_lavador_select
  ON public.tipos_veiculo_lavador
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

CREATE POLICY tipos_veiculo_lavador_insert
  ON public.tipos_veiculo_lavador
  FOR INSERT
  TO authenticated
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY tipos_veiculo_lavador_update
  ON public.tipos_veiculo_lavador
  FOR UPDATE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'))
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY tipos_veiculo_lavador_delete
  ON public.tipos_veiculo_lavador
  FOR DELETE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

-- ---------------------------------------------
-- 5.5 jornadas_lavador
--     ADMIN: CRUD
--     GESTAO_FROTA: CRUD
--     LAVADOR: SELECT
-- ---------------------------------------------
CREATE POLICY jornadas_lavador_select
  ON public.jornadas_lavador
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

CREATE POLICY jornadas_lavador_insert
  ON public.jornadas_lavador
  FOR INSERT
  TO authenticated
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY jornadas_lavador_update
  ON public.jornadas_lavador
  FOR UPDATE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'))
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY jornadas_lavador_delete
  ON public.jornadas_lavador
  FOR DELETE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

-- ---------------------------------------------
-- 5.6 calendario_operacional
--     ADMIN: CRUD
--     GESTAO_FROTA: CRUD
--     LAVADOR: SELECT
-- ---------------------------------------------
CREATE POLICY calendario_operacional_select
  ON public.calendario_operacional
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

CREATE POLICY calendario_operacional_insert
  ON public.calendario_operacional
  FOR INSERT
  TO authenticated
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY calendario_operacional_update
  ON public.calendario_operacional
  FOR UPDATE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'))
  WITH CHECK (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

CREATE POLICY calendario_operacional_delete
  ON public.calendario_operacional
  FOR DELETE
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA'));

-- ---------------------------------------------
-- 5.7 reservas_lavagem
--     Read only (SELECT) for all profiles.
--     Writes will be done via future RPCs only.
-- ---------------------------------------------
CREATE POLICY reservas_lavagem_select
  ON public.reservas_lavagem
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

-- ---------------------------------------------
-- 5.8 eventos_reserva (audit table)
--     Read only (SELECT) for all profiles.
--     Writes will be done via future RPCs only.
-- ---------------------------------------------
CREATE POLICY eventos_reserva_select
  ON public.eventos_reserva
  FOR SELECT
  TO authenticated
  USING (public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR'));

-- =============================================
-- 6. Grants
--    anon: no direct access at all.
--    authenticated: only the SQL privileges
--    needed by the RLS policies.
-- =============================================

-- 6.1 anon — revoke everything
REVOKE ALL ON TABLE public.perfis_usuarios FROM anon;
REVOKE ALL ON TABLE public.tipos_veiculo_lavador FROM anon;
REVOKE ALL ON TABLE public.veiculos FROM anon;
REVOKE ALL ON TABLE public.jornadas_lavador FROM anon;
REVOKE ALL ON TABLE public.calendario_operacional FROM anon;
REVOKE ALL ON TABLE public.reservas_lavagem FROM anon;
REVOKE ALL ON TABLE public.eventos_reserva FROM anon;
REVOKE ALL ON TABLE public.solicitantes_lavagem FROM anon;

-- 6.2 authenticated — reset and grant only what is needed
REVOKE ALL ON TABLE public.perfis_usuarios FROM authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.perfis_usuarios TO authenticated;

REVOKE ALL ON TABLE public.solicitantes_lavagem FROM authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.solicitantes_lavagem TO authenticated;

REVOKE ALL ON TABLE public.veiculos FROM authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.veiculos TO authenticated;

REVOKE ALL ON TABLE public.tipos_veiculo_lavador FROM authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.tipos_veiculo_lavador TO authenticated;

REVOKE ALL ON TABLE public.jornadas_lavador FROM authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.jornadas_lavador TO authenticated;

REVOKE ALL ON TABLE public.calendario_operacional FROM authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.calendario_operacional TO authenticated;

REVOKE ALL ON TABLE public.reservas_lavagem FROM authenticated;
GRANT SELECT ON TABLE public.reservas_lavagem TO authenticated;

REVOKE ALL ON TABLE public.eventos_reserva FROM authenticated;
GRANT SELECT ON TABLE public.eventos_reserva TO authenticated;

-- =============================================
-- 7. Harden consultar_disponibilidade()
--    Keep SECURITY INVOKER and logic; only
--    qualify schema + safe search_path + grants.
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
    SELECT 1 FROM public.jornadas_lavador WHERE regime = v_regime
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

REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO authenticated;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO service_role;

-- =============================================
-- 8. Reduce update_updated_at_column() exposure
--    (trigger function; triggers keep working)
-- =============================================
REVOKE EXECUTE ON FUNCTION public.update_updated_at_column() FROM PUBLIC;
