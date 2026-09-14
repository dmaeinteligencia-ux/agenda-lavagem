-- =============================================
-- Migration: Fundação do fluxo de usuários
-- Date: 2026-09-14
-- Description: Etapa 1 do fluxo de cadastro/aprovação.
--   - Adiciona nome e status_acesso em perfis_usuarios
--   - Backfill do ADMIN atual para ATIVO
--   - Cria current_user_tem_acesso()
--   - Cria handle_new_user() + trigger em auth.users
--     (auto-cria perfil LAVADOR/PENDENTE no signup)
--
-- NÃO altera policies, RLS ou grants de tabela.
-- =============================================

-- =============================================
-- 1. Colunas novas em perfis_usuarios
-- =============================================
ALTER TABLE public.perfis_usuarios
  ADD COLUMN nome text;

ALTER TABLE public.perfis_usuarios
  ADD COLUMN status_acesso text NOT NULL DEFAULT 'PENDENTE';

ALTER TABLE public.perfis_usuarios
  ADD CONSTRAINT perfis_usuarios_status_acesso_check
  CHECK (status_acesso IN ('PENDENTE', 'ATIVO', 'BLOQUEADO'));

-- =============================================
-- 2. Backfill do ADMIN atual (status ATIVO)
-- =============================================
UPDATE public.perfis_usuarios
SET status_acesso = 'ATIVO'
WHERE id = '22765ceb-6d7d-4532-8612-2de955c35628'::uuid;

-- =============================================
-- 3. current_user_tem_acesso()
-- =============================================
CREATE OR REPLACE FUNCTION public.current_user_tem_acesso()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.perfis_usuarios p
    WHERE p.id = auth.uid()
      AND p.status_acesso = 'ATIVO'
  );
$$;

REVOKE EXECUTE ON FUNCTION public.current_user_tem_acesso() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.current_user_tem_acesso() FROM anon;
GRANT EXECUTE ON FUNCTION public.current_user_tem_acesso() TO authenticated;
GRANT EXECUTE ON FUNCTION public.current_user_tem_acesso() TO service_role;

-- =============================================
-- 4. handle_new_user() (auto-criação de perfil)
-- =============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_nome text;
BEGIN
  v_nome := NULLIF(btrim(NEW.raw_user_meta_data ->> 'full_name'), '');

  INSERT INTO public.perfis_usuarios (id, nome, perfil, status_acesso)
  VALUES (NEW.id, v_nome, 'LAVADOR', 'PENDENTE')
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM anon;
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM service_role;

-- =============================================
-- 5. Trigger AFTER INSERT em auth.users
-- =============================================
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
