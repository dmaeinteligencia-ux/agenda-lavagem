-- =============================================
-- Migration: Endurecer policies com status_acesso
-- Date: 2026-09-14
-- Description: Etapa 2 do fluxo de usuários.
--   Acrescenta public.current_user_tem_acesso() às
--   policies de acesso interno, de modo que somente
--   usuários ATIVOS acessem as áreas internas.
--
--   Exceção: perfis_usuarios_select_own permanece
--   acessível a qualquer usuário autenticado (para ler
--   o próprio perfil/status — PENDENTE/BLOQUEADO).
--
-- NÃO altera tabelas, colunas, funções, triggers,
-- grants de tabela, RPCs de negócio ou o fluxo público
-- /nova-reserva. Preserva a lógica de perfil existente.
-- =============================================

-- ============ calendario_operacional ============
ALTER POLICY calendario_operacional_delete ON public.calendario_operacional
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY calendario_operacional_insert ON public.calendario_operacional
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY calendario_operacional_select ON public.calendario_operacional
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text, 'LAVADOR'::text]));

ALTER POLICY calendario_operacional_update ON public.calendario_operacional
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]))
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

-- ============ eventos_reserva ============
ALTER POLICY eventos_reserva_select ON public.eventos_reserva
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text, 'LAVADOR'::text]));

-- ============ jornadas_lavador ============
ALTER POLICY jornadas_lavador_delete ON public.jornadas_lavador
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY jornadas_lavador_insert ON public.jornadas_lavador
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY jornadas_lavador_select ON public.jornadas_lavador
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text, 'LAVADOR'::text]));

ALTER POLICY jornadas_lavador_update ON public.jornadas_lavador
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]))
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

-- ============ perfis_usuarios (exceto select_own) ============
ALTER POLICY perfis_usuarios_delete_admin ON public.perfis_usuarios
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN'::text);

ALTER POLICY perfis_usuarios_insert_admin ON public.perfis_usuarios
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN'::text);

ALTER POLICY perfis_usuarios_select_admin ON public.perfis_usuarios
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN'::text);

ALTER POLICY perfis_usuarios_update_admin ON public.perfis_usuarios
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN'::text)
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN'::text);

-- ============ reservas_lavagem ============
ALTER POLICY reservas_lavagem_select ON public.reservas_lavagem
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text, 'LAVADOR'::text]));

-- ============ solicitantes_lavagem ============
ALTER POLICY solicitantes_lavagem_delete ON public.solicitantes_lavagem
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN'::text);

ALTER POLICY solicitantes_lavagem_insert ON public.solicitantes_lavagem
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY solicitantes_lavagem_select ON public.solicitantes_lavagem
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text, 'LAVADOR'::text]));

ALTER POLICY solicitantes_lavagem_update ON public.solicitantes_lavagem
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]))
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

-- ============ tipos_veiculo_lavador ============
ALTER POLICY tipos_veiculo_lavador_delete ON public.tipos_veiculo_lavador
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY tipos_veiculo_lavador_insert ON public.tipos_veiculo_lavador
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY tipos_veiculo_lavador_select ON public.tipos_veiculo_lavador
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text, 'LAVADOR'::text]));

ALTER POLICY tipos_veiculo_lavador_update ON public.tipos_veiculo_lavador
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]))
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

-- ============ veiculos ============
ALTER POLICY veiculos_delete ON public.veiculos
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = 'ADMIN'::text);

ALTER POLICY veiculos_insert ON public.veiculos
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));

ALTER POLICY veiculos_select ON public.veiculos
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text, 'LAVADOR'::text]));

ALTER POLICY veiculos_update ON public.veiculos
  USING (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]))
  WITH CHECK (public.current_user_tem_acesso() AND public.current_user_perfil() = ANY (ARRAY['ADMIN'::text, 'GESTAO_FROTA'::text]));
