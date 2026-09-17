-- =============================================
-- Migration: Relatório diário de utilização do lavador
-- Date: 2026-09-17
-- Description:
--   Cria public.relatorio_utilizacao_lavador(p_data_inicial, p_data_final)
--   que retorna UMA LINHA POR DIA do período (inclusive dias sem reserva,
--   finais de semana, feriados e dias sem atendimento).
--
--   Regras (sem duplicar lógica existente):
--     - regime/ativo/feriado/override: public.resolver_dia_operacional(data)
--     - capacidade: jornadas_lavador.horas_disponiveis * 60 do regime resolvido
--     - utilizado: SUM(tempo_estimado) das reservas com status que consomem
--       capacidade (RESERVADA, EM_LAVAGEM, CONCLUIDA, NAO_CONCLUIDA)
--     - disponivel: capacidade - utilizado (SEM clamp; pode ser negativo)
--     - percentual: utilizado / capacidade * 100 (sem clamp; NULL se capacidade 0)
--     - total_reservas: COUNT(*) de todos os status do dia
--     - concluidas: COUNT(*) FILTER status = 'CONCLUIDA'
--     - ocorrencias: COUNT(*) FILTER status IN
--       ('NAO_COMPARECEU','NAO_ATENDIDA','NAO_CONCLUIDA')
--
--   Segurança: SECURITY DEFINER + validação interna de perfil
--   (ADMIN ou GESTAO_FROTA) e status de acesso ATIVO.
--
--   NÃO altera resolver_dia_operacional, consultar_disponibilidade,
--   criar_reserva_lavagem, jornadas_lavador, tabelas, RLS, policies,
--   triggers nem índices.
-- =============================================

CREATE FUNCTION public.relatorio_utilizacao_lavador(
  p_data_inicial date,
  p_data_final date
)
RETURNS TABLE (
  data date,
  regime text,
  ativo boolean,
  eh_feriado boolean,
  nome_feriado text,
  abrangencia_feriado text,
  tem_configuracao_manual boolean,
  tipo_configuracao text,
  observacao_calendario text,
  capacidade_minutos integer,
  utilizado_minutos integer,
  disponivel_minutos integer,
  percentual_utilizacao numeric,
  total_reservas bigint,
  concluidas bigint,
  ocorrencias bigint
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_regime_faltante text;
BEGIN
  -- 1. Autorização (ADMIN ou GESTAO_FROTA, ambos com acesso ATIVO)
  IF NOT (
    public.current_user_tem_acesso()
    AND public.current_user_perfil() IN ('ADMIN', 'GESTAO_FROTA')
  ) THEN
    RAISE EXCEPTION 'Acesso não autorizado.'
      USING ERRCODE = '42501',
            HINT = 'Este relatório é permitido apenas para ADMIN ou GESTAO_FROTA ativos.';
  END IF;

  -- 2. Validações de entrada
  IF p_data_inicial IS NULL THEN
    RAISE EXCEPTION 'Data inicial inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a data inicial do período.';
  END IF;

  IF p_data_final IS NULL THEN
    RAISE EXCEPTION 'Data final inválida.'
      USING ERRCODE = '22023', HINT = 'Informe a data final do período.';
  END IF;

  IF p_data_inicial > p_data_final THEN
    RAISE EXCEPTION 'Período inválido.'
      USING ERRCODE = '22023',
            HINT = 'A data inicial não pode ser posterior à data final.';
  END IF;

  IF (p_data_final - p_data_inicial + 1) > 366 THEN
    RAISE EXCEPTION 'Período máximo excedido.'
      USING ERRCODE = '22023', HINT = 'O período máximo permitido é de 366 dias.';
  END IF;

  -- 3. Jornada configurada para todos os regimes do período
  --    (não retornar capacidade zero silenciosamente)
  SELECT r.regime
    INTO v_regime_faltante
  FROM generate_series(p_data_inicial, p_data_final, interval '1 day') AS d(dia)
  CROSS JOIN LATERAL public.resolver_dia_operacional(d.dia::date) r
  LEFT JOIN public.jornadas_lavador jl ON jl.regime = r.regime
  WHERE jl.regime IS NULL
  LIMIT 1;

  IF v_regime_faltante IS NOT NULL THEN
    RAISE EXCEPTION 'Jornada não configurada para o regime da data.'
      USING HINT = 'Configure a jornada para o regime ' || v_regime_faltante || ' em jornadas_lavador.';
  END IF;

  -- 4. Resultado diário (todos os dias do período)
  RETURN QUERY
  WITH dias AS (
    SELECT d.dia::date AS data
    FROM generate_series(p_data_inicial, p_data_final, interval '1 day') AS d(dia)
  ),
  reservas_por_dia AS (
    SELECT
      rl.data_reserva AS data,
      COALESCE(SUM(rl.tempo_estimado) FILTER (
        WHERE rl.status IN ('RESERVADA', 'EM_LAVAGEM', 'CONCLUIDA', 'NAO_CONCLUIDA')
      ), 0)::integer AS utilizado_minutos,
      COUNT(*) AS total_reservas,
      COUNT(*) FILTER (WHERE rl.status = 'CONCLUIDA') AS concluidas,
      COUNT(*) FILTER (
        WHERE rl.status IN ('NAO_COMPARECEU', 'NAO_ATENDIDA', 'NAO_CONCLUIDA')
      ) AS ocorrencias
    FROM public.reservas_lavagem rl
    WHERE rl.data_reserva BETWEEN p_data_inicial AND p_data_final
    GROUP BY rl.data_reserva
  )
  SELECT
    d.data,
    r.regime,
    r.ativo,
    r.eh_feriado,
    r.nome_feriado,
    r.abrangencia_feriado,
    r.tem_configuracao_manual,
    c.tipo_configuracao,
    c.observacao AS observacao_calendario,
    (jl.horas_disponiveis * 60)::integer AS capacidade_minutos,
    COALESCE(rpd.utilizado_minutos, 0) AS utilizado_minutos,
    (jl.horas_disponiveis * 60 - COALESCE(rpd.utilizado_minutos, 0))::integer AS disponivel_minutos,
    ROUND(
      COALESCE(rpd.utilizado_minutos, 0)::numeric
        / NULLIF(jl.horas_disponiveis * 60, 0)
        * 100,
      1
    ) AS percentual_utilizacao,
    COALESCE(rpd.total_reservas, 0)::bigint AS total_reservas,
    COALESCE(rpd.concluidas, 0)::bigint AS concluidas,
    COALESCE(rpd.ocorrencias, 0)::bigint AS ocorrencias
  FROM dias d
  CROSS JOIN LATERAL public.resolver_dia_operacional(d.data) r
  JOIN public.jornadas_lavador jl ON jl.regime = r.regime
  LEFT JOIN public.calendario_operacional c ON c.data = d.data
  LEFT JOIN reservas_por_dia rpd ON rpd.data = d.data
  ORDER BY d.data ASC;
END;
$function$;

-- =============================================
-- Documentação
-- =============================================
COMMENT ON FUNCTION public.relatorio_utilizacao_lavador(date, date) IS
  'Relatório diário de utilização do lavador: uma linha por dia do período '
  '(inclusive dias sem reserva, finais de semana, feriados e dias sem atendimento). '
  'A capacidade é calculada a partir da configuração VIGENTE de jornada '
  '(jornadas_lavador) e da resolução operacional da data (resolver_dia_operacional), '
  'e o utilizado é a soma de reservas_lavagem.tempo_estimado dos status que consomem '
  'capacidade (RESERVADA, EM_LAVAGEM, CONCLUIDA, NAO_CONCLUIDA). '
  'disponivel_minutos pode ser negativo e percentual_utilizacao pode exceder 100% '
  '(sem clamp, para preservar excesso de capacidade). '
  'LIMITAÇÃO HISTÓRICA: jornadas_lavador e calendario_operacional representam a '
  'configuração ATUAL, sem vigência/snapshot. Portanto, para períodos passados, '
  'capacidade/regime/atendimento refletem alterações posteriores de jornada ou '
  'calendário. O utilizado_minutos é estável (tempo estimado congelado por reserva).';

-- =============================================
-- Grants
-- =============================================
REVOKE ALL ON FUNCTION public.relatorio_utilizacao_lavador(date, date) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.relatorio_utilizacao_lavador(date, date) FROM anon;
GRANT EXECUTE ON FUNCTION public.relatorio_utilizacao_lavador(date, date) TO authenticated, service_role;
