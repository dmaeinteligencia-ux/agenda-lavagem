-- =============================================
-- Migration: Remove o relatório de utilização do lavador
-- Date: 2026-09-17
-- Description:
--   Remove public.relatorio_utilizacao_lavador(date, date), criada pela
--   migration 20260917120000_create_relatorio_utilizacao_lavador.sql.
--
--   Funcionalidade retirada por decisão de produto (não será utilizada).
--   O relatório nunca foi integrado ao frontend.
--
--   Remove SOMENTE esta função. Não usa CASCADE. Não altera nenhuma outra
--   função (resolver_dia_operacional, consultar_disponibilidade,
--   criar_reserva_lavagem, cancelar_reserva_lavagem, iniciar_lavagem,
--   concluir_lavagem, registrar_nao_comparecimento, registrar_nao_atendimento,
--   registrar_nao_conclusao), tabelas, RLS, policies ou grants.
-- =============================================

DROP FUNCTION IF EXISTS public.relatorio_utilizacao_lavador(date, date);
