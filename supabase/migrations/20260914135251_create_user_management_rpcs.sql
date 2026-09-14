-- =============================================
-- Migration: RPCs administrativas de usuários
-- Date: 2026-09-14
-- Description: Etapa 3 do fluxo de usuários.
--   RPCs de gestão de usuários para uso exclusivo por
--   ADMIN ATIVO:
--     - listar_usuarios()
--     - alterar_status_usuario(uuid, text)
--     - alterar_perfil_usuario(uuid, text)
--
--   A autorização é validada DENTRO de cada função via
--   current_user_tem_acesso() AND current_user_perfil()='ADMIN'.
--   Proteção do "último ADMIN ATIVO" via advisory lock global
--   (namespace 2) serializando as mutações administrativas.
--
-- Também remove a escrita direta em perfis_usuarios (policies
-- de INSERT/UPDATE/DELETE + grants), tornando perfil/status
-- mutáveis exclusivamente via estas RPCs (garantindo o advisory
-- lock e a proteção do último ADMIN ATIVO).
-- =============================================

-- =============================================
-- 1. listar_usuarios()
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
    u.email,
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

-- =============================================
-- 2. alterar_status_usuario(uuid, text)
-- =============================================
CREATE OR REPLACE FUNCTION public.alterar_status_usuario(
  p_usuario_id uuid,
  p_novo_status text
)
RETURNS TABLE (
  id uuid,
  nome text,
  perfil text,
  status_acesso text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_perfil_atual text;
  v_status_atual text;
  v_admins_ativos integer;
BEGIN
  IF NOT (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN') THEN
    RAISE EXCEPTION 'Acesso não autorizado.'
      USING HINT = 'Esta operação é restrita a administradores ativos.';
  END IF;

  IF p_usuario_id IS NULL THEN
    RAISE EXCEPTION 'Usuário inválido.'
      USING ERRCODE = '22023', HINT = 'Informe o identificador do usuário.';
  END IF;

  IF p_novo_status IS NULL OR p_novo_status NOT IN ('PENDENTE', 'ATIVO', 'BLOQUEADO') THEN
    RAISE EXCEPTION 'Status de acesso inválido.'
      USING ERRCODE = '22023', HINT = 'Os valores válidos são PENDENTE, ATIVO e BLOQUEADO.';
  END IF;

  -- Lock global para mutações administrativas (protege o último ADMIN ATIVO)
  PERFORM pg_advisory_xact_lock(2, 1);

  SELECT p.perfil, p.status_acesso
  INTO v_perfil_atual, v_status_atual
  FROM public.perfis_usuarios p
  WHERE p.id = p_usuario_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Usuário não encontrado.'
      USING HINT = 'Verifique o identificador do usuário.';
  END IF;

  IF v_perfil_atual = 'ADMIN' AND v_status_atual = 'ATIVO' AND p_novo_status <> 'ATIVO' THEN
    SELECT count(*) INTO v_admins_ativos
    FROM public.perfis_usuarios p
    WHERE p.perfil = 'ADMIN' AND p.status_acesso = 'ATIVO';

    IF v_admins_ativos <= 1 THEN
      RAISE EXCEPTION 'Não é possível bloquear ou deixar pendente o último administrador ativo.'
        USING HINT = 'O sistema deve manter ao menos um administrador ativo.';
    END IF;
  END IF;

  UPDATE public.perfis_usuarios AS pu
  SET status_acesso = p_novo_status
  WHERE pu.id = p_usuario_id;

  RETURN QUERY
  SELECT p.id, p.nome, p.perfil, p.status_acesso
  FROM public.perfis_usuarios p
  WHERE p.id = p_usuario_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.alterar_status_usuario(uuid, text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.alterar_status_usuario(uuid, text) FROM anon;
REVOKE EXECUTE ON FUNCTION public.alterar_status_usuario(uuid, text) FROM service_role;
GRANT EXECUTE ON FUNCTION public.alterar_status_usuario(uuid, text) TO authenticated;

-- =============================================
-- 3. alterar_perfil_usuario(uuid, text)
-- =============================================
CREATE OR REPLACE FUNCTION public.alterar_perfil_usuario(
  p_usuario_id uuid,
  p_novo_perfil text
)
RETURNS TABLE (
  id uuid,
  nome text,
  perfil text,
  status_acesso text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_perfil_atual text;
  v_status_atual text;
  v_admins_ativos integer;
BEGIN
  IF NOT (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN') THEN
    RAISE EXCEPTION 'Acesso não autorizado.'
      USING HINT = 'Esta operação é restrita a administradores ativos.';
  END IF;

  IF p_usuario_id IS NULL THEN
    RAISE EXCEPTION 'Usuário inválido.'
      USING ERRCODE = '22023', HINT = 'Informe o identificador do usuário.';
  END IF;

  IF p_novo_perfil IS NULL OR p_novo_perfil NOT IN ('ADMIN', 'GESTAO_FROTA', 'LAVADOR') THEN
    RAISE EXCEPTION 'Perfil inválido.'
      USING ERRCODE = '22023', HINT = 'Os valores válidos são ADMIN, GESTAO_FROTA e LAVADOR.';
  END IF;

  -- Lock global para mutações administrativas (protege o último ADMIN ATIVO)
  PERFORM pg_advisory_xact_lock(2, 1);

  SELECT p.perfil, p.status_acesso
  INTO v_perfil_atual, v_status_atual
  FROM public.perfis_usuarios p
  WHERE p.id = p_usuario_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Usuário não encontrado.'
      USING HINT = 'Verifique o identificador do usuário.';
  END IF;

  IF v_perfil_atual = 'ADMIN' AND v_status_atual = 'ATIVO' AND p_novo_perfil <> 'ADMIN' THEN
    SELECT count(*) INTO v_admins_ativos
    FROM public.perfis_usuarios p
    WHERE p.perfil = 'ADMIN' AND p.status_acesso = 'ATIVO';

    IF v_admins_ativos <= 1 THEN
      RAISE EXCEPTION 'Não é possível alterar o perfil do último administrador ativo.'
        USING HINT = 'O sistema deve manter ao menos um administrador ativo.';
    END IF;
  END IF;

  UPDATE public.perfis_usuarios AS pu
  SET perfil = p_novo_perfil
  WHERE pu.id = p_usuario_id;

  RETURN QUERY
  SELECT p.id, p.nome, p.perfil, p.status_acesso
  FROM public.perfis_usuarios p
  WHERE p.id = p_usuario_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.alterar_perfil_usuario(uuid, text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.alterar_perfil_usuario(uuid, text) FROM anon;
REVOKE EXECUTE ON FUNCTION public.alterar_perfil_usuario(uuid, text) FROM service_role;
GRANT EXECUTE ON FUNCTION public.alterar_perfil_usuario(uuid, text) TO authenticated;

-- =============================================
-- 4. Remover escrita direta em perfis_usuarios
-- =============================================
DROP POLICY IF EXISTS perfis_usuarios_insert_admin ON public.perfis_usuarios;
DROP POLICY IF EXISTS perfis_usuarios_update_admin ON public.perfis_usuarios;
DROP POLICY IF EXISTS perfis_usuarios_delete_admin ON public.perfis_usuarios;

REVOKE INSERT, UPDATE, DELETE ON public.perfis_usuarios FROM authenticated;
