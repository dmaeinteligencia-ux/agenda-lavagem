-- =============================================
-- Migration: Auto cadastro público de solicitante
-- Date: 2026-09-17
-- Description:
--   Cria public.cadastrar_solicitante_publico(p_nome, p_matricula, p_telefone)
--   para permitir que a página pública /nova-reserva cadastre um solicitante
--   quando a matrícula informada não existe.
--
--   IMPORTANTE:
--     - NÃO cria auth.users nem perfis_usuarios (solicitante NÃO é usuário).
--     - A RPC escreve SOMENTE em public.solicitantes_lavagem.
--     - NÃO abre INSERT anon direto na tabela; o acesso público é exclusivo
--       por esta função (SECURITY DEFINER).
--     - NÃO altera RLS/policies nem grants de tabela.
--     - Matrícula continua UNIQUE; corrida tratada com unique_violation,
--       retornando o registro existente de forma idempotente.
--
--   RISCO CONHECIDO: endpoint público. Mitigações atuais: poucos campos,
--   validação explícita, escrita restrita a uma tabela e UNIQUE de matrícula.
--   Sem captcha/rate-limit customizado (avaliar futuramente).
-- =============================================

CREATE FUNCTION public.cadastrar_solicitante_publico(
  p_nome text,
  p_matricula text,
  p_telefone text
)
RETURNS TABLE (
  id uuid,
  nome text,
  matricula text,
  telefone text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_nome text;
  v_matricula text;
  v_telefone text;
  v_id uuid;
BEGIN
  -- 1. Validações de entrada (mesma regra do módulo /solicitantes: obrigatório + trim)
  v_nome := btrim(COALESCE(p_nome, ''));
  v_matricula := btrim(COALESCE(p_matricula, ''));
  v_telefone := btrim(COALESCE(p_telefone, ''));

  IF v_matricula = '' THEN
    RAISE EXCEPTION 'Matrícula inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a matrícula do solicitante.';
  END IF;

  IF v_nome = '' THEN
    RAISE EXCEPTION 'Nome inválido.'
      USING ERRCODE = '22023', HINT = 'Informe o nome do solicitante.';
  END IF;

  IF v_telefone = '' THEN
    RAISE EXCEPTION 'Telefone inválido.'
      USING ERRCODE = '22023', HINT = 'Informe o telefone do solicitante.';
  END IF;

  -- 2. INSERT (a UNIQUE da matrícula é a autoridade final)
  BEGIN
    INSERT INTO public.solicitantes_lavagem (nome, matricula, telefone)
    VALUES (v_nome, v_matricula, v_telefone)
    RETURNING solicitantes_lavagem.id INTO v_id;
  EXCEPTION
    WHEN unique_violation THEN
      -- Corrida: outra requisição já cadastrou a mesma matrícula.
      -- Retorna o registro existente (idempotente).
      SELECT s.id INTO v_id
      FROM public.solicitantes_lavagem s
      WHERE s.matricula = v_matricula;
  END;

  IF v_id IS NULL THEN
    RAISE EXCEPTION 'Não foi possível cadastrar o solicitante.'
      USING ERRCODE = '23505',
            HINT = 'Tente novamente ou pesquise a matrícula.';
  END IF;

  -- 3. Retorno do registro (novo ou existente)
  RETURN QUERY
  SELECT s.id, s.nome, s.matricula, s.telefone
  FROM public.solicitantes_lavagem s
  WHERE s.id = v_id;
END;
$function$;

-- =============================================
-- Documentação
-- =============================================
COMMENT ON FUNCTION public.cadastrar_solicitante_publico(text, text, text) IS
  'Auto cadastro público de solicitante usado pela página /nova-reserva. '
  'Escreve apenas em solicitantes_lavagem (nome, matricula, telefone). '
  'Não cria usuários/perfis. Matrícula UNIQUE; em corrida retorna o registro '
  'existente. Endpoint público: avaliar captcha/rate-limit futuramente.';

-- =============================================
-- Grants
-- =============================================
REVOKE ALL ON FUNCTION public.cadastrar_solicitante_publico(text, text, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.cadastrar_solicitante_publico(text, text, text)
  TO anon, authenticated, service_role;
