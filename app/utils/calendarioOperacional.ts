export type RegimeOperacional = 'NORMAL' | 'PLANTAO'
export type TipoConfiguracao = 'PONTO_FACULTATIVO' | 'FERIADO' | 'OUTRO'
export type AbrangenciaFeriado = 'NACIONAL' | 'ESTADUAL' | 'MUNICIPAL'

export interface CalendarioConfiguracao {
  id: string
  data: string
  regime: RegimeOperacional
  ativo: boolean
  tipo_configuracao: TipoConfiguracao
  observacao: string | null
}

export interface FeriadoOficial {
  id: string
  data: string
  nome: string
  abrangencia: AbrangenciaFeriado
}

export interface CalendarioOperacionalFormData {
  data: string
  regime: RegimeOperacional
  ativo: boolean
  tipo_configuracao: TipoConfiguracao
  observacao: string
}

export interface CalendarioOperacionalSugestao {
  data: string
  regime: RegimeOperacional
  ativo: boolean
  tipo_configuracao: TipoConfiguracao
}

export interface DiaOperacional {
  data: string
  regime: RegimeOperacional
  ativo: boolean
  feriado: FeriadoOficial | null
  configuracao: CalendarioConfiguracao | null
}

export interface ResumoCalendario {
  configuracoes: number
  plantoes: number
  semAtendimento: number
}

export const MESES = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro'
]

export const DIAS_SEMANA_ABREV = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB']

export const REGIME_OPCOES: { value: RegimeOperacional; label: string }[] = [
  { value: 'NORMAL', label: 'NORMAL' },
  { value: 'PLANTAO', label: 'PLANTÃO' }
]

export const TIPO_CONFIGURACAO_OPCOES: { value: TipoConfiguracao; label: string }[] = [
  { value: 'PONTO_FACULTATIVO', label: 'Ponto facultativo' },
  { value: 'FERIADO', label: 'Feriado' },
  { value: 'OUTRO', label: 'Outro' }
]

export const TIPO_CONFIGURACAO_LABELS: Record<TipoConfiguracao, string> = {
  PONTO_FACULTATIVO: 'Ponto facultativo',
  FERIADO: 'Feriado',
  OUTRO: 'Outro'
}

export const ABRANGENCIA_LABELS: Record<AbrangenciaFeriado, string> = {
  NACIONAL: 'Feriado nacional',
  ESTADUAL: 'Feriado estadual',
  MUNICIPAL: 'Feriado municipal'
}

export function getDiasNoMes(ano: number, mes: number): number {
  return new Date(ano, mes + 1, 0).getDate()
}

export function getPrimeiroDiaDaSemana(ano: number, mes: number): number {
  return new Date(ano, mes, 1).getDay()
}

export function toISODate(ano: number, mes: number, dia: number): string {
  return `${ano}-${String(mes + 1).padStart(2, '0')}-${String(dia).padStart(2, '0')}`
}

export function formatarData(iso: string): string {
  const [y, m, d] = iso.split('-')
  return `${d}/${m}/${y}`
}

export function isFimDeSemana(iso: string): boolean {
  const [y, m, d] = iso.split('-').map(Number)
  const dow = new Date(y, m - 1, d).getDay()
  return dow === 0 || dow === 6
}

export function getRegimePadrao(iso: string): RegimeOperacional {
  return isFimDeSemana(iso) ? 'PLANTAO' : 'NORMAL'
}

export function hojeISO(): string {
  const agora = new Date()
  return toISODate(agora.getFullYear(), agora.getMonth(), agora.getDate())
}

export function ehDataHoje(iso: string): boolean {
  return iso === hojeISO()
}

export function intervaloMes(ano: number, mes: number): { inicio: string; fim: string } {
  return {
    inicio: toISODate(ano, mes, 1),
    fim: toISODate(ano, mes, getDiasNoMes(ano, mes))
  }
}

export function resolverDia(
  data: string,
  feriado: FeriadoOficial | null,
  configuracao: CalendarioConfiguracao | null
): DiaOperacional {
  let regime: RegimeOperacional = feriado ? 'PLANTAO' : getRegimePadrao(data)
  let ativo = true

  if (configuracao) {
    regime = configuracao.regime
    ativo = configuracao.ativo
  }

  return { data, regime, ativo, feriado, configuracao }
}

export function contextoDia(dia: DiaOperacional): string | null {
  if (dia.feriado) {
    return `${ABRANGENCIA_LABELS[dia.feriado.abrangencia]} — ${dia.feriado.nome}`
  }

  if (dia.configuracao) {
    if (dia.configuracao.tipo_configuracao === 'PONTO_FACULTATIVO') {
      return 'Ponto facultativo'
    }
    if (dia.configuracao.tipo_configuracao === 'FERIADO') {
      return 'Feriado (configuração manual)'
    }
    if (dia.configuracao.observacao) {
      return dia.configuracao.observacao
    }
    return 'Configuração manual'
  }

  return null
}

export function resumoDoMes(configuracoes: CalendarioConfiguracao[]): ResumoCalendario {
  return {
    configuracoes: configuracoes.length,
    plantoes: configuracoes.filter((config) => config.regime === 'PLANTAO').length,
    semAtendimento: configuracoes.filter((config) => !config.ativo).length
  }
}
