-- =============================================
-- Migration: expand_reserva_operational_statuses
-- Date: 2026-09-15
-- Description: Amplia as CHECK constraints de status de
-- reserva/eventos para suportar os novos desfechos
-- operacionais:
--   - NAO_COMPARECEU  (RESERVADA -> NAO_COMPARECEU)
--   - NAO_ATENDIDA    (RESERVADA -> NAO_ATENDIDA)
--   - NAO_CONCLUIDA   (EM_LAVAGEM -> NAO_CONCLUIDA)
-- E os novos tipos de evento de auditoria:
--   - NAO_COMPARECIMENTO
--   - NAO_ATENDIMENTO
--   - NAO_CONCLUSAO
--
-- Apenas amplia as listas permitidas. Não altera colunas,
-- NOT NULL, FKs, índices, triggers, defaults, RLS, policies
-- ou grants. Não cria funções/RPCs. Não altera regras de
-- capacidade. EXPIRADA permanece suportada tecnicamente,
-- sem automação nesta etapa.
-- =============================================

-- =============================================
-- 1. reservas_lavagem.status
-- =============================================
ALTER TABLE public.reservas_lavagem
  DROP CONSTRAINT reservas_lavagem_status_check;

ALTER TABLE public.reservas_lavagem
  ADD CONSTRAINT reservas_lavagem_status_check
  CHECK (status IN (
    'RESERVADA',
    'EM_LAVAGEM',
    'CONCLUIDA',
    'CANCELADA',
    'EXPIRADA',
    'NAO_COMPARECEU',
    'NAO_ATENDIDA',
    'NAO_CONCLUIDA'
  ));

-- =============================================
-- 2. eventos_reserva.status_anterior
-- =============================================
ALTER TABLE public.eventos_reserva
  DROP CONSTRAINT eventos_reserva_status_anterior_check;

ALTER TABLE public.eventos_reserva
  ADD CONSTRAINT eventos_reserva_status_anterior_check
  CHECK (status_anterior IN (
    'RESERVADA',
    'EM_LAVAGEM',
    'CONCLUIDA',
    'CANCELADA',
    'EXPIRADA',
    'NAO_COMPARECEU',
    'NAO_ATENDIDA',
    'NAO_CONCLUIDA'
  ));

-- =============================================
-- 3. eventos_reserva.status_novo
-- =============================================
ALTER TABLE public.eventos_reserva
  DROP CONSTRAINT eventos_reserva_status_novo_check;

ALTER TABLE public.eventos_reserva
  ADD CONSTRAINT eventos_reserva_status_novo_check
  CHECK (status_novo IN (
    'RESERVADA',
    'EM_LAVAGEM',
    'CONCLUIDA',
    'CANCELADA',
    'EXPIRADA',
    'NAO_COMPARECEU',
    'NAO_ATENDIDA',
    'NAO_CONCLUIDA'
  ));

-- =============================================
-- 4. eventos_reserva.tipo_evento
-- =============================================
ALTER TABLE public.eventos_reserva
  DROP CONSTRAINT eventos_reserva_tipo_evento_check;

ALTER TABLE public.eventos_reserva
  ADD CONSTRAINT eventos_reserva_tipo_evento_check
  CHECK (tipo_evento IN (
    'CRIACAO',
    'ALTERACAO_STATUS',
    'CANCELAMENTO',
    'EXPIRACAO',
    'NAO_COMPARECIMENTO',
    'NAO_ATENDIMENTO',
    'NAO_CONCLUSAO'
  ));
