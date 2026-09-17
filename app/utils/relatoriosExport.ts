import type { Workbook as ExcelJSWorkbook } from 'exceljs'
import { STATUS_LABELS, toISODate } from '@/utils/reservas'
import {
  formatarDataCurta,
  formatarDataHora,
  labelMotivo,
  type TipoVeiculoAdmin
} from '@/utils/reservasAdmin'
import {
  TIPO_RELATORIO_TITULOS,
  formatarDuracao,
  formatarPeriodo,
  textoFiltros,
  type RelatorioFiltros,
  type RelatorioLinha,
  type RelatorioVeiculoLinha,
  type ResumoRelatorio,
  type TipoRelatorio
} from '@/utils/relatorios'

export const ORGAO_RELATORIO = 'DMAE'
export const SETOR_RELATORIO = 'Gestão do Lavador da Frota'

export type CelulaExport = string | number | Date | null

export type TipoColunaExport = 'texto' | 'data' | 'datahora' | 'numero'

export interface ColunaRelatorio {
  excel: string
  pdf: string
  tipo: TipoColunaExport
}

export interface LinhaResumo {
  label: string
  value: string | number
}

export interface CabecalhoRelatorio {
  orgao: string
  setor: string
  titulo: string
  periodo: string
  emitidoEm: string
  filtros: string
}

export interface RelatorioExportPayload {
  tipo: TipoRelatorio
  filtros: RelatorioFiltros
  tipos: TipoVeiculoAdmin[]
  linhas: RelatorioLinha[]
  veiculos: RelatorioVeiculoLinha[]
  resumo: ResumoRelatorio
}

export interface DadosExcel {
  aba: string
  cabecalho: CabecalhoRelatorio
  resumo: LinhaResumo[]
  colunas: ColunaRelatorio[]
  linhas: CelulaExport[][]
  nomeArquivo: string
}

export interface DadosPdf {
  cabecalho: CabecalhoRelatorio
  resumo: LinhaResumo[]
  colunas: string[]
  linhas: string[][]
  nomeArquivo: string
}

export interface ExcelJSModule {
  Workbook: new () => ExcelJSWorkbook
}

const SLUG_TIPO: Record<TipoRelatorio, string> = {
  RESERVAS: 'reservas',
  LAVAGENS: 'lavagens',
  OCORRENCIAS: 'ocorrencias',
  POR_VEICULO: 'por-veiculo'
}

const ABA_TIPO: Record<TipoRelatorio, string> = {
  RESERVAS: 'Reservas',
  LAVAGENS: 'Lavagens',
  OCORRENCIAS: 'Ocorrências',
  POR_VEICULO: 'Por Veículo'
}

const COLUNAS: Record<TipoRelatorio, ColunaRelatorio[]> = {
  RESERVAS: [
    { excel: 'Data', pdf: 'Data', tipo: 'data' },
    { excel: 'Veículo', pdf: 'Veículo', tipo: 'texto' },
    { excel: 'Placa', pdf: 'Placa', tipo: 'texto' },
    { excel: 'Tipo', pdf: 'Tipo', tipo: 'texto' },
    { excel: 'Solicitante', pdf: 'Solicitante', tipo: 'texto' },
    { excel: 'Matrícula', pdf: 'Matrícula', tipo: 'texto' },
    { excel: 'Tempo estimado (min)', pdf: 'Tempo (min)', tipo: 'numero' },
    { excel: 'Status', pdf: 'Status', tipo: 'texto' },
    { excel: 'Observação', pdf: 'Observação', tipo: 'texto' }
  ],
  LAVAGENS: [
    { excel: 'Data', pdf: 'Data', tipo: 'data' },
    { excel: 'Veículo', pdf: 'Veículo', tipo: 'texto' },
    { excel: 'Placa', pdf: 'Placa', tipo: 'texto' },
    { excel: 'Tipo', pdf: 'Tipo', tipo: 'texto' },
    { excel: 'Solicitante', pdf: 'Solicitante', tipo: 'texto' },
    { excel: 'Início', pdf: 'Início', tipo: 'datahora' },
    { excel: 'Fim', pdf: 'Fim', tipo: 'datahora' },
    { excel: 'Duração real (min)', pdf: 'Duração', tipo: 'numero' },
    { excel: 'Tempo estimado (min)', pdf: 'Estimado', tipo: 'numero' }
  ],
  OCORRENCIAS: [
    { excel: 'Data', pdf: 'Data', tipo: 'data' },
    { excel: 'Veículo', pdf: 'Veículo', tipo: 'texto' },
    { excel: 'Placa', pdf: 'Placa', tipo: 'texto' },
    { excel: 'Solicitante', pdf: 'Solicitante', tipo: 'texto' },
    { excel: 'Ocorrência', pdf: 'Ocorrência', tipo: 'texto' },
    { excel: 'Motivo', pdf: 'Motivo', tipo: 'texto' },
    { excel: 'Observação', pdf: 'Observação', tipo: 'texto' },
    { excel: 'Registrado em', pdf: 'Registrado em', tipo: 'datahora' }
  ],
  POR_VEICULO: [
    { excel: 'Veículo', pdf: 'Veículo', tipo: 'texto' },
    { excel: 'Placa', pdf: 'Placa', tipo: 'texto' },
    { excel: 'Tipo', pdf: 'Tipo', tipo: 'texto' },
    { excel: 'Total de reservas', pdf: 'Reservas', tipo: 'numero' },
    { excel: 'Concluídas', pdf: 'Concluídas', tipo: 'numero' },
    { excel: 'Ocorrências', pdf: 'Ocorrências', tipo: 'numero' },
    { excel: 'Última lavagem', pdf: 'Última lavagem', tipo: 'data' }
  ]
}

const LARGURAS_COLUNAS: Record<string, number> = {
  Observação: 42,
  Solicitante: 24,
  Veículo: 18,
  Motivo: 26,
  Tipo: 22,
  'Última lavagem': 16,
  'Registrado em': 18,
  Início: 18,
  Fim: 18
}

export function colunasRelatorio(tipo: TipoRelatorio): ColunaRelatorio[] {
  return COLUNAS[tipo]
}

export function nomeAbaRelatorio(tipo: TipoRelatorio): string {
  return ABA_TIPO[tipo]
}

export function nomeArquivoRelatorio(
  tipo: TipoRelatorio,
  filtros: RelatorioFiltros,
  extensao: 'xlsx' | 'pdf'
): string {
  const inicio = filtros.dataInicial || 'inicio'
  const fim = filtros.dataFinal || 'fim'

  return `gestao-lavador-${SLUG_TIPO[tipo]}-${inicio}-a-${fim}.${extensao}`
}

export function dataIsoParaDate(iso: string): Date | null {
  const [ano, mes, dia] = iso.split('-').map(Number)

  if (!ano || !mes || !dia) {
    return null
  }

  return new Date(ano, mes - 1, dia)
}

export function dataHoraParaDate(iso: string | null): Date | null {
  if (!iso) {
    return null
  }

  const data = new Date(iso)
  return Number.isNaN(data.getTime()) ? null : data
}

export function montarCabecalho(
  tipo: TipoRelatorio,
  filtros: RelatorioFiltros,
  tipos: TipoVeiculoAdmin[],
  emitidoEm: string
): CabecalhoRelatorio {
  return {
    orgao: ORGAO_RELATORIO,
    setor: SETOR_RELATORIO,
    titulo: TIPO_RELATORIO_TITULOS[tipo],
    periodo: formatarPeriodo(filtros.dataInicial, filtros.dataFinal),
    emitidoEm: formatarDataHora(emitidoEm),
    filtros: textoFiltros(tipo, filtros, tipos)
  }
}

export function linhasResumo(resumo: ResumoRelatorio): LinhaResumo[] {
  switch (resumo.tipo) {
    case 'LAVAGENS':
      return [
        { label: 'Lavagens realizadas', value: resumo.dados.total },
        { label: 'Tempo estimado total', value: formatarDuracao(resumo.dados.tempoEstimadoTotal) },
        { label: 'Tempo real total', value: formatarDuracao(resumo.dados.tempoRealTotal) },
        {
          label: 'Durações registradas',
          value: `${resumo.dados.comDuracao} de ${resumo.dados.total}`
        }
      ]
    case 'OCORRENCIAS':
      return [
        { label: 'Total', value: resumo.dados.total },
        { label: 'Não compareceu', value: resumo.dados.naoCompareceu },
        { label: 'Não atendida', value: resumo.dados.naoAtendida },
        { label: 'Não concluída', value: resumo.dados.naoConcluida }
      ]
    case 'POR_VEICULO':
      return [
        { label: 'Veículos no período', value: resumo.dados.veiculos },
        { label: 'Reservas', value: resumo.dados.totalReservas },
        { label: 'Concluídas', value: resumo.dados.totalConcluidas },
        { label: 'Ocorrências', value: resumo.dados.totalOcorrencias }
      ]
    default:
      return [
        { label: 'Total', value: resumo.dados.total },
        { label: 'Reservadas', value: resumo.dados.reservadas },
        { label: 'Concluídas', value: resumo.dados.concluidas },
        { label: 'Ocorrências', value: resumo.dados.ocorrencias }
      ]
  }
}

export function montarLinhasTabela(
  tipo: TipoRelatorio,
  linhas: RelatorioLinha[],
  veiculos: RelatorioVeiculoLinha[]
): CelulaExport[][] {
  if (tipo === 'POR_VEICULO') {
    return veiculos.map((item) => [
      item.veiculo,
      item.placa,
      item.tipo,
      item.total,
      item.concluidas,
      item.ocorrencias,
      item.ultimaLavagem ? dataIsoParaDate(item.ultimaLavagem) : null
    ])
  }

  return linhas.map((linha) => {
    if (tipo === 'LAVAGENS') {
      return [
        dataIsoParaDate(linha.data),
        linha.veiculo,
        linha.placa,
        linha.tipo,
        linha.solicitante,
        dataHoraParaDate(linha.inicio),
        dataHoraParaDate(linha.fim),
        linha.duracaoRealMinutos,
        linha.tempoEstimado
      ]
    }

    if (tipo === 'OCORRENCIAS') {
      return [
        dataIsoParaDate(linha.data),
        linha.veiculo,
        linha.placa,
        linha.solicitante,
        STATUS_LABELS[linha.status],
        labelMotivo(linha.motivo),
        linha.observacaoEvento,
        dataHoraParaDate(linha.registradoEm)
      ]
    }

    return [
      dataIsoParaDate(linha.data),
      linha.veiculo,
      linha.placa,
      linha.tipo,
      linha.solicitante,
      linha.matricula,
      linha.tempoEstimado,
      STATUS_LABELS[linha.status],
      linha.observacao
    ]
  })
}

export function formatarCelulaPdf(valor: CelulaExport, tipo: TipoColunaExport): string {
  if (valor === null || valor === undefined || valor === '') {
    return ''
  }

  if (valor instanceof Date) {
    return tipo === 'data'
      ? formatarDataCurta(toISODate(valor))
      : formatarDataHora(valor.toISOString())
  }

  return String(valor)
}

export function montarDadosExcel(payload: RelatorioExportPayload): DadosExcel {
  const emitidoEm = new Date().toISOString()

  return {
    aba: nomeAbaRelatorio(payload.tipo),
    cabecalho: montarCabecalho(payload.tipo, payload.filtros, payload.tipos, emitidoEm),
    resumo: linhasResumo(payload.resumo),
    colunas: colunasRelatorio(payload.tipo),
    linhas: montarLinhasTabela(payload.tipo, payload.linhas, payload.veiculos),
    nomeArquivo: nomeArquivoRelatorio(payload.tipo, payload.filtros, 'xlsx')
  }
}

export function montarDadosPdf(payload: RelatorioExportPayload): DadosPdf {
  const colunas = colunasRelatorio(payload.tipo)
  const linhas = montarLinhasTabela(payload.tipo, payload.linhas, payload.veiculos)

  return {
    cabecalho: montarCabecalho(
      payload.tipo,
      payload.filtros,
      payload.tipos,
      new Date().toISOString()
    ),
    resumo: linhasResumo(payload.resumo),
    colunas: colunas.map((coluna) => coluna.pdf),
    linhas: linhas.map((linha) =>
      linha.map((valor, indice) => formatarCelulaPdf(valor, colunas[indice]?.tipo ?? 'texto'))
    ),
    nomeArquivo: nomeArquivoRelatorio(payload.tipo, payload.filtros, 'pdf')
  }
}

function larguraColuna(coluna: ColunaRelatorio): number {
  const largura = LARGURAS_COLUNAS[coluna.excel]

  if (largura) {
    return largura
  }

  if (coluna.tipo === 'data') {
    return 12
  }

  if (coluna.tipo === 'datahora') {
    return 18
  }

  if (coluna.tipo === 'numero') {
    return 14
  }

  return 20
}

export function montarWorkbook(ExcelJS: ExcelJSModule, dados: DadosExcel): ExcelJSWorkbook {
  const workbook = new ExcelJS.Workbook()
  const worksheet = workbook.addWorksheet(dados.aba)
  const totalColunas = dados.colunas.length

  const linhasCabecalho = [
    { texto: dados.cabecalho.orgao, bold: true, size: 14 },
    { texto: dados.cabecalho.setor, bold: false, size: 10 },
    { texto: dados.cabecalho.titulo, bold: true, size: 12 },
    { texto: `Período: ${dados.cabecalho.periodo}`, bold: false, size: 10 },
    { texto: `Emitido em: ${dados.cabecalho.emitidoEm}`, bold: false, size: 10 },
    { texto: `Filtros: ${dados.cabecalho.filtros}`, bold: false, size: 10 }
  ]

  for (const item of linhasCabecalho) {
    const row = worksheet.addRow([item.texto])
    row.getCell(1).font = { bold: item.bold, size: item.size }
  }

  worksheet.addRow([])

  const tituloResumo = worksheet.addRow(['Resumo'])
  tituloResumo.getCell(1).font = { bold: true, size: 11 }

  for (const item of dados.resumo) {
    const row = worksheet.addRow([item.label, item.value])
    row.getCell(1).font = { size: 10 }
    row.getCell(2).font = { size: 10 }
  }

  worksheet.addRow([])

  const headerRow = worksheet.addRow(dados.colunas.map((coluna) => coluna.excel))

  headerRow.eachCell({ includeEmpty: true }, (cell) => {
    cell.font = { bold: true, size: 10 }
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF1F5F9' } }
    cell.border = {
      top: { style: 'thin', color: { argb: 'FFD1D5DB' } },
      left: { style: 'thin', color: { argb: 'FFD1D5DB' } },
      bottom: { style: 'thin', color: { argb: 'FFD1D5DB' } },
      right: { style: 'thin', color: { argb: 'FFD1D5DB' } }
    }
    cell.alignment = { vertical: 'middle' }
  })

  for (const valores of dados.linhas) {
    const row = worksheet.addRow(valores)

    row.eachCell({ includeEmpty: true }, (cell, colNumber) => {
      const coluna = dados.colunas[colNumber - 1]
      cell.font = { size: 10 }
      cell.alignment = { vertical: 'top', wrapText: true }
      cell.border = {
        top: { style: 'thin', color: { argb: 'FFE5E7EB' } },
        left: { style: 'thin', color: { argb: 'FFE5E7EB' } },
        bottom: { style: 'thin', color: { argb: 'FFE5E7EB' } },
        right: { style: 'thin', color: { argb: 'FFE5E7EB' } }
      }

      if (coluna?.tipo === 'data') {
        cell.numFmt = 'dd/mm/yyyy'
      } else if (coluna?.tipo === 'datahora') {
        cell.numFmt = 'dd/mm/yyyy hh:mm'
      }
    })
  }

  dados.colunas.forEach((coluna, indice) => {
    worksheet.getColumn(indice + 1).width = larguraColuna(coluna)
  })

  worksheet.autoFilter = {
    from: { row: headerRow.number, column: 1 },
    to: { row: headerRow.number, column: totalColunas }
  }

  worksheet.views = [{ state: 'frozen', ySplit: headerRow.number }]

  return workbook
}
