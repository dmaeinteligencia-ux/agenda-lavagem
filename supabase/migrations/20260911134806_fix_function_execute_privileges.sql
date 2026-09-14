-- =============================================
-- Migration: Fix function EXECUTE privileges
-- Date: 2026-09-11
-- Description: Corrective migration to align the
-- EXECUTE grants of the public functions with the
-- security model. Does not touch RLS, policies,
-- table grants, functions bodies or constraints.
-- =============================================

-- =============================================
-- 1. current_user_perfil()
--    PUBLIC / anon / service_role: no EXECUTE
--    authenticated: EXECUTE
-- =============================================
REVOKE EXECUTE ON FUNCTION public.current_user_perfil() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.current_user_perfil() FROM anon;
REVOKE EXECUTE ON FUNCTION public.current_user_perfil() FROM service_role;

GRANT EXECUTE ON FUNCTION public.current_user_perfil() TO authenticated;

-- =============================================
-- 2. consultar_disponibilidade(uuid, date)
--    PUBLIC / anon: no EXECUTE
--    authenticated / service_role: EXECUTE
-- =============================================
REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) FROM anon;

GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO authenticated;
GRANT EXECUTE ON FUNCTION public.consultar_disponibilidade(uuid, date) TO service_role;

-- =============================================
-- 3. update_updated_at_column()
--    Trigger function: no EXECUTE for app roles
-- =============================================
REVOKE EXECUTE ON FUNCTION public.update_updated_at_column() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.update_updated_at_column() FROM anon;
REVOKE EXECUTE ON FUNCTION public.update_updated_at_column() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.update_updated_at_column() FROM service_role;
