-- =============================================
-- Migration: Create public.concluir_lavagem()
-- Date: 2026-09-15
-- Description: RPC de conclusão de lavagem para usuários
-- ativos com perfil ADMIN ou LAVADOR. Transição permitida
-- apenas EM_LAVAGEM -> CONCLUIDA, com lock de linha
-- (FOR UPDATE) para concorrência e evento de auditoria
-- atômico.
--
-- NÃO altera tabelas, constraints, RLS, policies, grants
-- de tabela, triggers ou outras funções.
-- =============================================

CREATE OR REPLACE FUNCTION public.concluir_lavagem(
  p_reserva_id uuid,
  p_observacao text DEFAULT NULL
)
RETURNS TABLE (
  id uuid,
  solicitante_id uuid,
  veiculo_id uuid,
  data_reserva date,
  status text,
  tempo_estimado integer,
  observacao text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_status_atual text;
  v_observacao text;
BEGIN
  -- 1. Autorização (ADMIN ou LAVADOR, ambos ATIVOS)
  IF NOT (
    public.current_user_tem_acesso()
    AND public.current_user_perfil() IN ('ADMIN', 'LAVADOR')
  ) THEN
    RAISE EXCEPTION 'Acesso não autorizado.'
      USING HINT = 'Esta operação é permitida apenas para administradores e lavadores ativos.';
  END IF;

  -- 2. Validação de entrada
  IF p_reserva_id IS NULL THEN
    RAISE EXCEPTION 'Reserva inválida.'
      USING ERRCODE = '22023', HINT = 'Informe o identificador da reserva.';
  END IF;

  v_observacao := NULLIF(btrim(p_observacao), '');

  -- 3. Lock de linha (proteção contra concorrência na mesma reserva)
  SELECT r.status
  INTO v_status_atual
  FROM public.reservas_lavagem r
  WHERE r.id = p_reserva_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Reserva não encontrada.'
      USING HINT = 'Verifique o identificador da reserva.';
  END IF;

  -- 4. Transição permitida: somente EM_LAVAGEM -> CONCLUIDA
  IF v_status_atual <> 'EM_LAVAGEM' THEN
    RAISE EXCEPTION 'A lavagem não pode ser concluída no status atual.'
      USING HINT = 'Somente reservas com status EM_LAVAGEM podem ser concluídas.';
  END IF;

  -- 5. Conclusão da lavagem
  UPDATE public.reservas_lavagem r
  SET status = 'CONCLUIDA'
  WHERE r.id = p_reserva_id;

  -- 6. Auditoria (atômica com a conclusão)
  INSERT INTO public.eventos_reserva (
    reserva_id,
    usuario_id,
    tipo_evento,
    status_anterior,
    status_novo,
    observacao
  )
  VALUES (
    p_reserva_id,
    auth.uid(),
    'ALTERACAO_STATUS',
    'EM_LAVAGEM',
    'CONCLUIDA',
    v_observacao
  );

  -- 7. Retorno
  RETURN QUERY
  SELECT
    r.id,
    r.solicitante_id,
    r.veiculo_id,
    r.data_reserva,
    r.status,
    r.tempo_estimado,
    r.observacao
  FROM public.reservas_lavagem r
  WHERE r.id = p_reserva_id;
END;
$$;

-- =============================================
-- Grants
-- =============================================
REVOKE EXECUTE ON FUNCTION public.concluir_lavagem(uuid, text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.concluir_lavagem(uuid, text) FROM anon;
REVOKE EXECUTE ON FUNCTION public.concluir_lavagem(uuid, text) FROM service_role;
GRANT EXECUTE ON FUNCTION public.concluir_lavagem(uuid, text) TO authenticated;
