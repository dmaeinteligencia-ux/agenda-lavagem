export type RegimeOperacional = 'NORMAL' | 'PLANTAO'

export interface CalendarioOperacionalMock {
  id: string
  data: string
  regime: RegimeOperacional
  observacao: string
}

export interface CalendarioOperacionalFormData {
  data: string
  regime: RegimeOperacional
  observacao: string
}

export const getDiaSemana = (dataISO: string): string => {
  const [y, m, d] = dataISO.split('-').map(Number)
  const date = new Date(y, m - 1, d)
  const dias = ['Domingo', 'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado']
  return dias[date.getDay()]
}

export const isFimDeSemana = (dataISO: string): boolean => {
  const [y, m, d] = dataISO.split('-').map(Number)
  const date = new Date(y, m - 1, d)
  const dow = date.getDay()
  return dow === 0 || dow === 6
}

export const formatarData = (dataISO: string): string => {
  const [y, m, d] = dataISO.split('-')
  return `${d}/${m}/${y}`
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

export const getRegimePadrao = (dataISO: string): RegimeOperacional =>
  isFimDeSemana(dataISO) ? 'PLANTAO' : 'NORMAL'

export const getDiasNoMes = (ano: number, mes: number): number =>
  new Date(ano, mes + 1, 0).getDate()

export const getPrimeiroDiaDaSemana = (ano: number, mes: number): number =>
  new Date(ano, mes, 1).getDay()

export const toISODate = (ano: number, mes: number, dia: number): string =>
  `${ano}-${String(mes + 1).padStart(2, '0')}-${String(dia).padStart(2, '0')}`

export interface CalendarioOperacionalSugestao {
  data: string
  regime: RegimeOperacional
}

export const configuracoesCalendarioMock: CalendarioOperacionalMock[] = [
  { id: '1', data: '2026-09-07', regime: 'PLANTAO', observacao: 'Feriado nacional — Independência do Brasil' },
  { id: '2', data: '2026-09-12', regime: 'NORMAL', observacao: 'Expediente especial' },
  { id: '3', data: '2026-09-19', regime: 'NORMAL', observacao: '' },
  { id: '4', data: '2026-09-26', regime: 'NORMAL', observacao: '' },
  { id: '5', data: '2026-10-12', regime: 'PLANTAO', observacao: 'Feriado nacional — Nossa Senhora Aparecida' },
  { id: '6', data: '2026-11-02', regime: 'PLANTAO', observacao: 'Feriado nacional — Finados' },
  { id: '7', data: '2026-11-21', regime: 'NORMAL', observacao: 'Mutirão de lavagem' },
  { id: '8', data: '2026-12-25', regime: 'PLANTAO', observacao: 'Feriado nacional — Natal' }
]
