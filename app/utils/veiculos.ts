export interface TipoVeiculo {
  id: string
  descricao: string
  tempo_min: number
}

export interface Veiculo {
  id: string
  nome_frota: string | null
  nr_placa_transport: string
  ds_modelo: string | null
  ds_combustivel: string | null
  ano: number | null
  tipo_veiculo_id: string | null
  ativo: boolean
  created_at: string
  updated_at: string
  tipo: TipoVeiculo | null
}

export interface VeiculoBaseRow {
  id: string
  nome_frota: string | null
  nr_placa_transport: string
  ds_modelo: string | null
  ds_combustivel: string | null
  ano: number | null
  tipo_veiculo_id: string | null
  ativo: boolean
  created_at: string
  updated_at: string
}

export interface VeiculoFormData {
  nome_frota: string
  nr_placa_transport: string
  ds_modelo: string
  ds_combustivel: string
  ano: string
  tipo_veiculo_id: string
  ativo: boolean
}

export interface VeiculoPayload {
  nome_frota: string | null
  nr_placa_transport: string
  ds_modelo: string | null
  ds_combustivel: string | null
  ano: number | null
  tipo_veiculo_id: string
  ativo: boolean
}

export type VeiculoSituacaoFiltro = 'TODOS' | 'ATIVOS' | 'INATIVOS'

export interface VeiculoFiltros {
  busca: string
  tipoId: string
  situacao: VeiculoSituacaoFiltro
}

export const VEICULOS_PAGE_SIZE = 12

export const FILTRO_TODOS_OS_TIPOS = ''

export const SITUACOES_VEICULO: { value: VeiculoSituacaoFiltro; label: string }[] = [
  { value: 'TODOS', label: 'Todos' },
  { value: 'ATIVOS', label: 'Ativos' },
  { value: 'INATIVOS', label: 'Inativos' }
]

export function normalizarPlaca(placa: string): string {
  return placa.toUpperCase().replace(/[^A-Z0-9]/g, '')
}

const emptyToNull = (valor: string): string | null => {
  const trimmed = valor.trim()
  return trimmed === '' ? null : trimmed
}

export function identificacaoVeiculo(veiculo: Veiculo): string {
  return veiculo.nome_frota || veiculo.ds_modelo || '—'
}

export function descricaoTipoVeiculo(veiculo: Veiculo): string {
  return veiculo.tipo?.descricao ?? '—'
}

export function mapVeiculo(row: VeiculoBaseRow, tipos: TipoVeiculo[]): Veiculo {
  const tipo = row.tipo_veiculo_id
    ? tipos.find((t) => t.id === row.tipo_veiculo_id) ?? null
    : null

  return {
    id: row.id,
    nome_frota: row.nome_frota,
    nr_placa_transport: row.nr_placa_transport,
    ds_modelo: row.ds_modelo,
    ds_combustivel: row.ds_combustivel,
    ano: row.ano,
    tipo_veiculo_id: row.tipo_veiculo_id,
    ativo: row.ativo,
    created_at: row.created_at,
    updated_at: row.updated_at,
    tipo
  }
}

export function veiculoToFormData(veiculo: Veiculo): VeiculoFormData {
  return {
    nome_frota: veiculo.nome_frota ?? '',
    nr_placa_transport: veiculo.nr_placa_transport,
    ds_modelo: veiculo.ds_modelo ?? '',
    ds_combustivel: veiculo.ds_combustivel ?? '',
    ano: veiculo.ano === null ? '' : String(veiculo.ano),
    tipo_veiculo_id: veiculo.tipo_veiculo_id ?? '',
    ativo: veiculo.ativo
  }
}

export function formDataInicial(): VeiculoFormData {
  return {
    nome_frota: '',
    nr_placa_transport: '',
    ds_modelo: '',
    ds_combustivel: '',
    ano: '',
    tipo_veiculo_id: '',
    ativo: true
  }
}

export function toVeiculoPayload(data: VeiculoFormData): VeiculoPayload {
  const anoTexto = data.ano.trim()
  const anoNumero = anoTexto === '' ? null : Number(anoTexto)

  return {
    nome_frota: emptyToNull(data.nome_frota),
    nr_placa_transport: normalizarPlaca(data.nr_placa_transport),
    ds_modelo: emptyToNull(data.ds_modelo),
    ds_combustivel: emptyToNull(data.ds_combustivel),
    ano: anoNumero === null || Number.isNaN(anoNumero) ? null : anoNumero,
    tipo_veiculo_id: data.tipo_veiculo_id,
    ativo: data.ativo
  }
}

export function veiculoCorrespondeBusca(veiculo: Veiculo, busca: string): boolean {
  const termo = busca.trim().toLowerCase()

  if (!termo) {
    return true
  }

  const campos = [
    veiculo.nome_frota ?? '',
    veiculo.nr_placa_transport,
    veiculo.ds_modelo ?? '',
    veiculo.tipo?.descricao ?? ''
  ]

  if (campos.some((campo) => campo.toLowerCase().includes(termo))) {
    return true
  }

  const termoPlaca = normalizarPlaca(busca)
  return termoPlaca.length > 0 && normalizarPlaca(veiculo.nr_placa_transport).includes(termoPlaca)
}

export function veiculoCorrespondeFiltros(veiculo: Veiculo, filtros: VeiculoFiltros): boolean {
  if (filtros.tipoId && veiculo.tipo_veiculo_id !== filtros.tipoId) {
    return false
  }

  if (filtros.situacao === 'ATIVOS' && !veiculo.ativo) {
    return false
  }

  if (filtros.situacao === 'INATIVOS' && veiculo.ativo) {
    return false
  }

  return veiculoCorrespondeBusca(veiculo, filtros.busca)
}
