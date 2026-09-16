-- =============================================
-- Migration: Feriados oficiais (referência operacional)
-- Date: 2026-09-16
-- Description:
--   Cria public.feriados_oficiais — base local e auditável de feriados
--   oficiais aplicáveis a Uberlândia (nacional/estadual/municipal).
--   NÃO inclui pontos facultativos (Carnaval, Cinzas, Corpus Christi
--   federal, Dia do Servidor, vésperas etc.) — esses pertencem à
--   configuração manual do ADMIN em calendario_operacional.
--   Fontes: legislação federal (Lei 662/1949, 6.802/1980, 9.093/1995,
--   14.759/2023) e calendário oficial da Prefeitura de Uberlândia
--   (aniversário da cidade). Não há feriado estadual de MG distinto
--   aplicável às datas de 2026 (21/04 coincide com feriado nacional).
-- =============================================

CREATE TABLE public.feriados_oficiais (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  data date NOT NULL,
  nome text NOT NULL,
  abrangencia text NOT NULL,
  uf text,
  municipio text,
  fonte text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT feriados_oficiais_abrangencia_check
    CHECK (abrangencia IN ('NACIONAL', 'ESTADUAL', 'MUNICIPAL'))
);

CREATE UNIQUE INDEX feriados_oficiais_data_nome_key
  ON public.feriados_oficiais (data, nome);

CREATE INDEX idx_feriados_oficiais_data
  ON public.feriados_oficiais (data);

CREATE TRIGGER set_updated_at_feriados_oficiais
  BEFORE UPDATE ON public.feriados_oficiais
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

ALTER TABLE public.feriados_oficiais ENABLE ROW LEVEL SECURITY;

-- Leitura apenas para usuários autenticados com acesso ativo.
-- Escrita não é exposta ao frontend (somente migration/service_role).
CREATE POLICY feriados_oficiais_select ON public.feriados_oficiais
  FOR SELECT TO authenticated
  USING (public.current_user_tem_acesso());

REVOKE ALL ON TABLE public.feriados_oficiais FROM anon;
REVOKE ALL ON TABLE public.feriados_oficiais FROM authenticated;
GRANT SELECT ON TABLE public.feriados_oficiais TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.feriados_oficiais TO service_role;

-- =============================================
-- Carga inicial — 2026
-- =============================================
INSERT INTO public.feriados_oficiais (data, nome, abrangencia, uf, municipio, fonte) VALUES
  ('2026-01-01', 'Confraternização Universal', 'NACIONAL', NULL, NULL, 'Lei federal nº 662/1949'),
  ('2026-04-03', 'Sexta-feira Santa (Paixão de Cristo)', 'NACIONAL', NULL, NULL, 'Lei federal nº 9.093/1995'),
  ('2026-04-21', 'Tiradentes', 'NACIONAL', NULL, NULL, 'Lei federal nº 662/1949'),
  ('2026-05-01', 'Dia do Trabalho', 'NACIONAL', NULL, NULL, 'Lei federal nº 662/1949'),
  ('2026-08-31', 'Aniversário de Uberlândia', 'MUNICIPAL', 'MG', 'Uberlândia', 'Calendário oficial da Prefeitura de Uberlândia'),
  ('2026-09-07', 'Independência do Brasil', 'NACIONAL', NULL, NULL, 'Lei federal nº 662/1949'),
  ('2026-10-12', 'Nossa Senhora Aparecida', 'NACIONAL', NULL, NULL, 'Lei federal nº 6.802/1980'),
  ('2026-11-02', 'Finados', 'NACIONAL', NULL, NULL, 'Lei federal nº 662/1949'),
  ('2026-11-15', 'Proclamação da República', 'NACIONAL', NULL, NULL, 'Lei federal nº 662/1949'),
  ('2026-11-20', 'Dia Nacional de Zumbi e da Consciência Negra', 'NACIONAL', NULL, NULL, 'Lei federal nº 14.759/2023'),
  ('2026-12-25', 'Natal', 'NACIONAL', NULL, NULL, 'Lei federal nº 662/1949');
