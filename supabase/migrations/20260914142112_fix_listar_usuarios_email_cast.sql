-- =============================================
-- Migration: Corrigir listar_usuarios() (email::text)
-- Date: 2026-09-14
-- Description: Correção mínima do bug 42804 em
-- listar_usuarios(): auth.users.email é varchar(255),
-- enquanto o RETURNS TABLE declara email text. O cast
-- u.email::text alinha o tipo retornado.
--
-- Nenhuma regra de negócio, policy, tabela ou grant de
-- tabela é alterado. Somente a função e seus grants de
-- EXECUTE são reapresentados.
-- =============================================

CREATE OR REPLACE FUNCTION public.listar_usuarios()
RETURNS TABLE (
  id uuid,
  nome text,
  email text,
  perfil text,
  status_acesso text,
  created_at timestamptz
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF NOT (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN') THEN
    RAISE EXCEPTION 'Acesso não autorizado.'
      USING HINT = 'Esta operação é restrita a administradores ativos.';
  END IF;

  RETURN QUERY
  SELECT
    p.id,
    p.nome,
    u.email::text,
    p.perfil,
    p.status_acesso,
    p.created_at
  FROM public.perfis_usuarios p
  JOIN auth.users u ON u.id = p.id
  ORDER BY p.nome NULLS LAST, u.email;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.listar_usuarios() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.listar_usuarios() FROM anon;
REVOKE EXECUTE ON FUNCTION public.listar_usuarios() FROM service_role;
GRANT EXECUTE ON FUNCTION public.listar_usuarios() TO authenticated;
