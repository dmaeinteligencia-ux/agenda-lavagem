import {
  STATUS_LABELS,
  toISODate,
  type ReservaStatus
} from '@/utils/reservas'
import {
  derivarHorarios,
  formatarDataCurta,
  reservaCorrespondeBusca,
  type EventoReserva,
  type ReservaAdmin,
  type TipoVeiculoAdmin
} from '@/utils/reservasAdmin'
import { normalizarPlaca } from '@/utils/veiculos'

export type TipoRelatorio = 'RESERVAS' | 'LAVAGENS' | 'OCORRENCIAS' | 'POR_VEICULO'

export type StatusOcorrencia = 'NAO_COMPARECEU' | 'NAO_ATENDIDA' | 'NAO_CONCLUIDA'

export const TIPO_RELATORIO_OPCOES: { value: TipoRelatorio; label: string }[] = [
  { value: 'RESERVAS', label: 'Reservas' },
  { value: 'LAVAGENS', label: 'Lavagens realizadas' },
  { value: 'OCORRENCIAS', label: 'Ocorrências' },
  { value: 'POR_VEICULO', label: 'Por veículo' }
]

export const TIPO_RELATORIO_TITULOS: Record<TipoRelatorio, string> = {
  RESERVAS: 'Relatório de Reservas',
  LAVAGENS: 'Relatório de Lavagens Realizadas',
  OCORRENCIAS: 'Relatório de Ocorrências',
  POR_VEICULO: 'Relatório por Veículo'
}

export const OCORRENCIA_STATUS: readonly StatusOcorrencia[] = [
  'NAO_COMPARECEU',
  'NAO_ATENDIDA',
  'NAO_CONCLUIDA'
]

export const OCORRENCIA_TIPO_EVENTO: Record<StatusOcorrencia, string> = {
  NAO_COMPARECEU: 'NAO_COMPARECIMENTO',
  NAO_ATENDIDA: 'NAO_ATENDIMENTO',
  NAO_CONCLUIDA: 'NAO_CONCLUSAO'
}

export const OCORRENCIA_OPCOES: { value: StatusOcorrencia; label: string }[] =
  OCORRENCIA_STATUS.map((status) => ({ value: status, label: STATUS_LABELS[status] }))

export const RELATORIOS_PAGE_SIZE = 20

export function ehStatusOcorrencia(status: ReservaStatus): status is StatusOcorrencia {
  return (OCORRENCIA_STATUS as readonly string[]).includes(status)
}

export interface RelatorioFiltros {
  dataInicial: string
  dataFinal: string
  status: string
  tipoId: string
  busca: string
  ocorrencia: string
}

export function periodoPadrao(): { dataInicial: string; dataFinal: string } {
  const hoje = new Date()
  const primeiroDia = new Date(hoje.getFullYear(), hoje.getMonth(), 1)

  return {
    dataInicial: toISODate(primeiroDia),
    dataFinal: toISODate(hoje)
  }
}

export function relatorioFiltrosIniciais(): RelatorioFiltros {
  const { dataInicial, dataFinal } = periodoPadrao()

  return {
    dataInicial,
    dataFinal,
    status: '',
    tipoId: '',
    busca: '',
    ocorrencia: ''
  }
}

export function periodoInvalido(filtros: RelatorioFiltros): boolean {
  if (!filtros.dataInicial || !filtros.dataFinal) {
    return false
  }

  return filtros.dataInicial > filtros.dataFinal
}

export interface RelatorioLinha extends ReservaAdmin {
  inicio: string | null
  fim: string | null
  duracaoRealMinutos: number | null
  motivo: string | null
  observacaoEvento: string | null
  tipoEvento: string | null
  registradoEm: string | null
}

export function eventoOcorrencia(
  status: ReservaStatus,
  eventos: EventoReserva[]
): EventoReserva | null {
  if (!ehStatusOcorrencia(status)) {
    return null
  }

  const tipoEvento = OCORRENCIA_TIPO_EVENTO[status]
  return eventos.filter((evento) => evento.tipo_evento === tipoEvento).pop() ?? null
}

export function duracaoRealMinutos(inicio: string | null, fim: string | null): number | null {
  if (!inicio || !fim) {
    return null
  }

  const inicioMs = new Date(inicio).getTime()
  const fimMs = new Date(fim).getTime()

  if (Number.isNaN(inicioMs) || Number.isNaN(fimMs) || fimMs < inicioMs) {
    return null
  }

  return Math.round((fimMs - inicioMs) / 60000)
}

export function formatarDuracao(minutos: number | null): string {
  if (minutos === null) {
    return '—'
  }

  if (minutos < 60) {
    return `${minutos} min`
  }

  const horas = Math.floor(minutos / 60)
  const resto = minutos % 60

  return resto === 0 ? `${horas}h` : `${horas}h ${resto}min`
}

export function montarLinhas(
  reservas: ReservaAdmin[],
  eventosPorReserva: Map<string, EventoReserva[]>
): RelatorioLinha[] {
  return reservas.map((reserva) => {
    const eventos = eventosPorReserva.get(reserva.id) ?? []
    const horarios = derivarHorarios(eventos)
    const ocorrencia = eventoOcorrencia(reserva.status, eventos)

    return {
      ...reserva,
      inicio: horarios.inicio,
      fim: horarios.fim,
      duracaoRealMinutos: duracaoRealMinutos(horarios.inicio, horarios.fim),
      motivo: ocorrencia?.motivo ?? null,
      observacaoEvento: ocorrencia?.observacao ?? null,
      tipoEvento: ocorrencia?.tipo_evento ?? null,
      registradoEm: ocorrencia?.created_at ?? null
    }
  })
}

function linhaCorrespondeBuscaVeiculo(linha: RelatorioLinha, busca: string): boolean {
  const termo = busca.trim().toLowerCase()

  if (!termo) {
    return true
  }

  const campos = [linha.veiculo, linha.placa, linha.modelo]

  if (campos.some((campo) => campo.toLowerCase().includes(termo))) {
    return true
  }

  const termoPlaca = normalizarPlaca(busca)
  return termoPlaca.length > 0 && normalizarPlaca(linha.placa).includes(termoPlaca)
}

export function filtrarLinhas(
  linhas: RelatorioLinha[],
  tipo: TipoRelatorio,
  filtros: RelatorioFiltros
): RelatorioLinha[] {
  return linhas.filter((linha) => {
    if (tipo === 'LAVAGENS' && linha.status !== 'CONCLUIDA') {
      return false
    }

    if (tipo === 'OCORRENCIAS' && !ehStatusOcorrencia(linha.status)) {
      return false
    }

    if (tipo === 'RESERVAS' && filtros.status && linha.status !== filtros.status) {
      return false
    }

    if (tipo === 'OCORRENCIAS' && filtros.ocorrencia && linha.status !== filtros.ocorrencia) {
      return false
    }

    if (filtros.tipoId && linha.tipoVeiculoId !== filtros.tipoId) {
      return false
    }

    if (filtros.dataInicial && linha.data < filtros.dataInicial) {
      return false
    }

    if (filtros.dataFinal && linha.data > filtros.dataFinal) {
      return false
    }

    if (tipo === 'POR_VEICULO') {
      return linhaCorrespondeBuscaVeiculo(linha, filtros.busca)
    }

    return reservaCorrespondeBusca(linha, filtros.busca)
  })
}

export interface ResumoReservas {
  total: number
  reservadas: number
  concluidas: number
  ocorrencias: number
}

export function resumoReservas(linhas: RelatorioLinha[]): ResumoReservas {
  return {
    total: linhas.length,
    reservadas: linhas.filter((linha) => linha.status === 'RESERVADA').length,
    concluidas: linhas.filter((linha) => linha.status === 'CONCLUIDA').length,
    ocorrencias: linhas.filter((linha) => ehStatusOcorrencia(linha.status)).length
  }
}

export interface ResumoLavagens {
  total: number
  tempoEstimadoTotal: number
  tempoRealTotal: number
  comDuracao: number
}

export function resumoLavagens(linhas: RelatorioLinha[]): ResumoLavagens {
  const duracoes = linhas
    .map((linha) => linha.duracaoRealMinutos)
    .filter((duracao): duracao is number => duracao !== null)

  return {
    total: linhas.length,
    tempoEstimadoTotal: linhas.reduce((total, linha) => total + linha.tempoEstimado, 0),
    tempoRealTotal: duracoes.reduce((total, duracao) => total + duracao, 0),
    comDuracao: duracoes.length
  }
}

export interface ResumoOcorrencias {
  total: number
  naoCompareceu: number
  naoAtendida: number
  naoConcluida: number
}

export function resumoOcorrencias(linhas: RelatorioLinha[]): ResumoOcorrencias {
  return {
    total: linhas.length,
    naoCompareceu: linhas.filter((linha) => linha.status === 'NAO_COMPARECEU').length,
    naoAtendida: linhas.filter((linha) => linha.status === 'NAO_ATENDIDA').length,
    naoConcluida: linhas.filter((linha) => linha.status === 'NAO_CONCLUIDA').length
  }
}

export interface RelatorioVeiculoLinha {
  veiculoId: string
  veiculo: string
  placa: string
  modelo: string
  tipo: string
  total: number
  concluidas: number
  ocorrencias: number
  ultimaLavagem: string | null
}

export function agruparPorVeiculo(linhas: RelatorioLinha[]): RelatorioVeiculoLinha[] {
  const mapa = new Map<string, RelatorioVeiculoLinha>()

  for (const linha of linhas) {
    const atual = mapa.get(linha.veiculoId) ?? {
      veiculoId: linha.veiculoId,
      veiculo: linha.veiculo,
      placa: linha.placa,
      modelo: linha.modelo,
      tipo: linha.tipo,
      total: 0,
      concluidas: 0,
      ocorrencias: 0,
      ultimaLavagem: null
    }

    atual.total += 1

    if (linha.status === 'CONCLUIDA') {
      atual.concluidas += 1

      if (!atual.ultimaLavagem || linha.data > atual.ultimaLavagem) {
        atual.ultimaLavagem = linha.data
      }
    }

    if (ehStatusOcorrencia(linha.status)) {
      atual.ocorrencias += 1
    }

    mapa.set(linha.veiculoId, atual)
  }

  return [...mapa.values()].sort((a, b) => a.veiculo.localeCompare(b.veiculo, 'pt-BR'))
}

export interface ResumoPorVeiculo {
  veiculos: number
  totalReservas: number
  totalConcluidas: number
  totalOcorrencias: number
}

export function resumoPorVeiculo(veiculos: RelatorioVeiculoLinha[]): ResumoPorVeiculo {
  return {
    veiculos: veiculos.length,
    totalReservas: veiculos.reduce((total, item) => total + item.total, 0),
    totalConcluidas: veiculos.reduce((total, item) => total + item.concluidas, 0),
    totalOcorrencias: veiculos.reduce((total, item) => total + item.ocorrencias, 0)
  }
}

export type ResumoRelatorio =
  | { tipo: 'RESERVAS'; dados: ResumoReservas }
  | { tipo: 'LAVAGENS'; dados: ResumoLavagens }
  | { tipo: 'OCORRENCIAS'; dados: ResumoOcorrencias }
  | { tipo: 'POR_VEICULO'; dados: ResumoPorVeiculo }

export function formatarPeriodo(dataInicial: string, dataFinal: string): string {
  if (!dataInicial && !dataFinal) {
    return '—'
  }

  if (!dataFinal) {
    return `a partir de ${formatarDataCurta(dataInicial)}`
  }

  if (!dataInicial) {
    return `até ${formatarDataCurta(dataFinal)}`
  }

  return `${formatarDataCurta(dataInicial)} a ${formatarDataCurta(dataFinal)}`
}

export function descreverFiltros(
  tipo: TipoRelatorio,
  filtros: RelatorioFiltros,
  tipos: TipoVeiculoAdmin[]
): string[] {
  const partes: string[] = [
    `Período: ${formatarPeriodo(filtros.dataInicial, filtros.dataFinal)}`
  ]

  if (tipo === 'LAVAGENS') {
    partes.push(`Status: ${STATUS_LABELS.CONCLUIDA}`)
  } else if (tipo === 'OCORRENCIAS') {
    const ocorrencia = filtros.ocorrencia as StatusOcorrencia
    partes.push(
      filtros.ocorrencia
        ? `Ocorrência: ${STATUS_LABELS[ocorrencia] ?? filtros.ocorrencia}`
        : 'Ocorrências: todas'
    )
  } else if (tipo === 'RESERVAS') {
    const status = filtros.status as ReservaStatus
    partes.push(
      filtros.status ? `Status: ${STATUS_LABELS[status] ?? filtros.status}` : 'Status: todos'
    )
  }

  if (filtros.tipoId) {
    const tipoVeiculo = tipos.find((item) => item.id === filtros.tipoId)
    partes.push(`Tipo de veículo: ${tipoVeiculo?.descricao ?? '—'}`)
  }

  if (filtros.busca.trim()) {
    partes.push(`Busca: ${filtros.busca.trim()}`)
  }

  return partes
}
