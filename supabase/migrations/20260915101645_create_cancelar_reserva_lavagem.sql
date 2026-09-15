-- =============================================
-- Migration: Create public.cancelar_reserva_lavagem()
-- Date: 2026-09-15
-- Description: RPC de cancelamento de reserva para uso
-- exclusivo por ADMIN ATIVO. Transição permitida apenas
-- RESERVADA -> CANCELADA, com lock de linha (FOR UPDATE)
-- para concorrência e evento de auditoria atômico.
--
-- NÃO altera tabelas, constraints, RLS, policies, grants
-- de tabela, triggers ou outras funções.
-- =============================================

CREATE OR REPLACE FUNCTION public.cancelar_reserva_lavagem(
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
  -- 1. Autorização (somente ADMIN ATIVO)
  IF NOT (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN') THEN
    RAISE EXCEPTION 'Acesso não autorizado.'
      USING HINT = 'Esta operação é restrita a administradores ativos.';
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

  -- 4. Transição permitida: somente RESERVADA -> CANCELADA
  IF v_status_atual <> 'RESERVADA' THEN
    RAISE EXCEPTION 'A reserva não pode ser cancelada no status atual.'
      USING HINT = 'Somente reservas com status RESERVADA podem ser canceladas.';
  END IF;

  -- 5. Cancelamento
  UPDATE public.reservas_lavagem r
  SET status = 'CANCELADA'
  WHERE r.id = p_reserva_id;

  -- 6. Auditoria (atômica com o cancelamento)
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
    'CANCELAMENTO',
    'RESERVADA',
    'CANCELADA',
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
REVOKE EXECUTE ON FUNCTION public.cancelar_reserva_lavagem(uuid, text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.cancelar_reserva_lavagem(uuid, text) FROM anon;
REVOKE EXECUTE ON FUNCTION public.cancelar_reserva_lavagem(uuid, text) FROM service_role;
GRANT EXECUTE ON FUNCTION public.cancelar_reserva_lavagem(uuid, text) TO authenticated;
