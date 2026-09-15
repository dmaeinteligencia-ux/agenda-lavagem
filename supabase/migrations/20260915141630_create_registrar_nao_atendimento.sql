-- =============================================
-- Migration: Create public.registrar_nao_atendimento()
-- Date: 2026-09-15
-- Description: RPC de não atendimento de reserva para
-- usuários ativos com perfil ADMIN ou LAVADOR. Transição
-- RESERVADA -> NAO_ATENDIDA, com motivo estruturado e
-- lock de linha (FOR UPDATE) + evento de auditoria atômico.
--
-- Adiciona a coluna nullable eventos_reserva.motivo com
-- CHECK dos motivos permitidos (eventos antigos permanecem
-- válidos com motivo NULL).
-- =============================================

-- =============================================
-- 1. Coluna estruturada para o motivo
-- =============================================
ALTER TABLE public.eventos_reserva
  ADD COLUMN motivo text;

ALTER TABLE public.eventos_reserva
  ADD CONSTRAINT eventos_reserva_motivo_check
  CHECK (motivo IN (
    'ATRASO_LAVAGENS_ANTERIORES',
    'FIM_DA_JORNADA',
    'INDISPONIBILIDADE_LAVADOR',
    'FALTA_AGUA',
    'FALHA_EQUIPAMENTO',
    'PROBLEMA_ESTRUTURAL',
    'PRIORIDADE_OPERACIONAL',
    'OUTRO'
  ));

-- =============================================
-- 2. RPC registrar_nao_atendimento()
-- =============================================
CREATE OR REPLACE FUNCTION public.registrar_nao_atendimento(
  p_reserva_id uuid,
  p_motivo text,
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
  v_motivo text;
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

  -- 3. Validação do motivo
  IF p_motivo IS NULL OR btrim(p_motivo) = '' THEN
    RAISE EXCEPTION 'Motivo obrigatório.'
      USING ERRCODE = '22023', HINT = 'Informe o motivo do não atendimento.';
  END IF;

  v_motivo := upper(btrim(p_motivo));

  IF v_motivo NOT IN (
    'ATRASO_LAVAGENS_ANTERIORES',
    'FIM_DA_JORNADA',
    'INDISPONIBILIDADE_LAVADOR',
    'FALTA_AGUA',
    'FALHA_EQUIPAMENTO',
    'PROBLEMA_ESTRUTURAL',
    'PRIORIDADE_OPERACIONAL',
    'OUTRO'
  ) THEN
    RAISE EXCEPTION 'Motivo de não atendimento inválido.'
      USING ERRCODE = '22023';
  END IF;

  v_observacao := NULLIF(btrim(p_observacao), '');

  IF v_motivo = 'OUTRO' AND v_observacao IS NULL THEN
    RAISE EXCEPTION 'A observação é obrigatória quando o motivo informado é OUTRO.'
      USING ERRCODE = '22023';
  END IF;

  -- 4. Lock de linha (proteção contra concorrência na mesma reserva)
  SELECT r.status
  INTO v_status_atual
  FROM public.reservas_lavagem r
  WHERE r.id = p_reserva_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Reserva não encontrada.'
      USING HINT = 'Verifique o identificador da reserva.';
  END IF;

  -- 5. Transição permitida: somente RESERVADA -> NAO_ATENDIDA
  IF v_status_atual <> 'RESERVADA' THEN
    RAISE EXCEPTION 'A reserva não pode ser marcada como não atendida no status atual.'
      USING HINT = 'Somente reservas com status RESERVADA podem ser classificadas como não atendidas.';
  END IF;

  -- 6. Registro de não atendimento
  UPDATE public.reservas_lavagem r
  SET status = 'NAO_ATENDIDA'
  WHERE r.id = p_reserva_id;

  -- 7. Auditoria (atômica com o registro)
  INSERT INTO public.eventos_reserva (
    reserva_id,
    usuario_id,
    tipo_evento,
    status_anterior,
    status_novo,
    motivo,
    observacao
  )
  VALUES (
    p_reserva_id,
    auth.uid(),
    'NAO_ATENDIMENTO',
    'RESERVADA',
    'NAO_ATENDIDA',
    v_motivo,
    v_observacao
  );

  -- 8. Retorno
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
REVOKE EXECUTE ON FUNCTION public.registrar_nao_atendimento(uuid, text, text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.registrar_nao_atendimento(uuid, text, text) FROM anon;
REVOKE EXECUTE ON FUNCTION public.registrar_nao_atendimento(uuid, text, text) FROM service_role;
GRANT EXECUTE ON FUNCTION public.registrar_nao_atendimento(uuid, text, text) TO authenticated;
