import { STATUS_LABELS, type ReservaStatus } from '@/utils/reservas'
import { normalizarPlaca } from '@/utils/veiculos'

export interface TipoVeiculoAdmin {
  id: string
  descricao: string
  tempo_min: number
}

export interface ReservaAdminBaseRow {
  id: string
  veiculo_id: string
  solicitante_id: string | null
  data_reserva: string
  status: ReservaStatus
  tempo_estimado: number
  observacao: string | null
  created_at: string
  updated_at: string
}

export interface VeiculoLookup {
  id: string
  nome_frota: string | null
  nr_placa_transport: string
  ds_modelo: string | null
  tipo_veiculo_id: string | null
}

export interface SolicitanteLookup {
  id: string
  nome: string | null
  matricula: string | null
}

export interface ReservaAdmin {
  id: string
  veiculoId: string
  solicitanteId: string | null
  veiculo: string
  placa: string
  modelo: string
  tipo: string
  tipoVeiculoId: string | null
  solicitante: string
  matricula: string
  data: string
  tempoEstimado: number
  status: ReservaStatus
  observacao: string | null
}

export interface EventoReserva {
  id: string
  reserva_id: string
  usuario_id: string | null
  status_anterior: ReservaStatus | null
  status_novo: ReservaStatus
  tipo_evento: string
  motivo: string | null
  observacao: string | null
  created_at: string
}

export interface HorariosReservaAdmin {
  inicio: string | null
  fim: string | null
}

export interface ReservaAdminFiltros {
  busca: string
  dataInicial: string
  dataFinal: string
  status: string
  tipoId: string
}

export const RESERVAS_PAGE_SIZE = 10

export const STATUS_OPCOES: { value: ReservaStatus; label: string }[] = [
  { value: 'RESERVADA', label: STATUS_LABELS.RESERVADA },
  { value: 'EM_LAVAGEM', label: STATUS_LABELS.EM_LAVAGEM },
  { value: 'CONCLUIDA', label: STATUS_LABELS.CONCLUIDA },
  { value: 'CANCELADA', label: STATUS_LABELS.CANCELADA },
  { value: 'EXPIRADA', label: STATUS_LABELS.EXPIRADA },
  { value: 'NAO_COMPARECEU', label: STATUS_LABELS.NAO_COMPARECEU },
  { value: 'NAO_ATENDIDA', label: STATUS_LABELS.NAO_ATENDIDA },
  { value: 'NAO_CONCLUIDA', label: STATUS_LABELS.NAO_CONCLUIDA }
]

export const TIPOS_EVENTO_LABELS: Record<string, string> = {
  CRIACAO: 'Criação',
  ALTERACAO_STATUS: 'Alteração de status',
  CANCELAMENTO: 'Cancelamento',
  EXPIRACAO: 'Expiração',
  NAO_COMPARECIMENTO: 'Não comparecimento',
  NAO_ATENDIMENTO: 'Não atendimento',
  NAO_CONCLUSAO: 'Não conclusão'
}

export const MOTIVOS_LABELS: Record<string, string> = {
  ATRASO_LAVAGENS_ANTERIORES: 'Atraso nas lavagens anteriores',
  FIM_DA_JORNADA: 'Fim da jornada',
  INDISPONIBILIDADE_LAVADOR: 'Indisponibilidade do lavador',
  FALTA_AGUA: 'Falta de água',
  FALHA_EQUIPAMENTO: 'Falha de equipamento',
  PROBLEMA_ESTRUTURAL: 'Problema de infraestrutura',
  PRIORIDADE_OPERACIONAL: 'Atendimento de demanda prioritária',
  OUTRO: 'Outro motivo'
}

export function formatarDataCurta(iso: string): string {
  const [ano, mes, dia] = iso.split('-')
  return `${dia}/${mes}/${ano}`
}

export function formatarDataHora(iso: string): string {
  const d = new Date(iso)

  if (Number.isNaN(d.getTime())) {
    return '—'
  }

  const dia = String(d.getDate()).padStart(2, '0')
  const mes = String(d.getMonth() + 1).padStart(2, '0')
  const ano = d.getFullYear()
  const hh = String(d.getHours()).padStart(2, '0')
  const mm = String(d.getMinutes()).padStart(2, '0')

  return `${dia}/${mes}/${ano} ${hh}:${mm}`
}

export function labelTipoEvento(tipo: string): string {
  return TIPOS_EVENTO_LABELS[tipo] ?? tipo
}

export function labelMotivo(motivo: string | null): string | null {
  if (!motivo) {
    return null
  }
  return MOTIVOS_LABELS[motivo] ?? motivo
}

export function mapReservaAdmin(
  row: ReservaAdminBaseRow,
  veiculos: Map<string, VeiculoLookup>,
  solicitantes: Map<string, SolicitanteLookup>,
  tipos: Map<string, TipoVeiculoAdmin>
): ReservaAdmin {
  const veiculo = veiculos.get(row.veiculo_id)
  const solicitante = row.solicitante_id ? solicitantes.get(row.solicitante_id) : undefined
  const tipo = veiculo?.tipo_veiculo_id ? tipos.get(veiculo.tipo_veiculo_id) : undefined

  return {
    id: row.id,
    veiculoId: row.veiculo_id,
    solicitanteId: row.solicitante_id,
    veiculo: veiculo?.nome_frota || veiculo?.ds_modelo || '—',
    placa: veiculo?.nr_placa_transport ?? '—',
    modelo: veiculo?.ds_modelo ?? '—',
    tipo: tipo?.descricao ?? '—',
    tipoVeiculoId: veiculo?.tipo_veiculo_id ?? null,
    solicitante: solicitante?.nome ?? '—',
    matricula: solicitante?.matricula ?? '—',
    data: row.data_reserva,
    tempoEstimado: row.tempo_estimado,
    status: row.status,
    observacao: row.observacao
  }
}

export function derivarHorarios(eventos: EventoReserva[]): HorariosReservaAdmin {
  let inicio: string | null = null
  let fim: string | null = null

  const ordenados = [...eventos].sort((a, b) => a.created_at.localeCompare(b.created_at))

  for (const ev of ordenados) {
    if (ev.status_anterior === 'RESERVADA' && ev.status_novo === 'EM_LAVAGEM') {
      inicio = ev.created_at
    } else if (ev.status_anterior === 'EM_LAVAGEM' && ev.status_novo === 'CONCLUIDA') {
      fim = ev.created_at
    } else if (ev.tipo_evento === 'NAO_CONCLUSAO') {
      fim = ev.created_at
    }
  }

  return { inicio, fim }
}

export function filtrosIniciais(): ReservaAdminFiltros {
  return {
    busca: '',
    dataInicial: '',
    dataFinal: '',
    status: '',
    tipoId: ''
  }
}

export function temFiltrosAtivos(filtros: ReservaAdminFiltros): boolean {
  return (
    filtros.busca.trim() !== '' ||
    filtros.dataInicial !== '' ||
    filtros.dataFinal !== '' ||
    filtros.status !== '' ||
    filtros.tipoId !== ''
  )
}

export function reservaCorrespondeBusca(reserva: ReservaAdmin, busca: string): boolean {
  const termo = busca.trim().toLowerCase()

  if (!termo) {
    return true
  }

  const campos = [reserva.veiculo, reserva.placa, reserva.modelo, reserva.solicitante, reserva.matricula]

  if (campos.some((campo) => campo.toLowerCase().includes(termo))) {
    return true
  }

  const termoPlaca = normalizarPlaca(busca)
  return termoPlaca.length > 0 && normalizarPlaca(reserva.placa).includes(termoPlaca)
}

export function reservaCorrespondeFiltros(
  reserva: ReservaAdmin,
  filtros: ReservaAdminFiltros
): boolean {
  if (filtros.status && reserva.status !== filtros.status) {
    return false
  }

  if (filtros.tipoId && reserva.tipoVeiculoId !== filtros.tipoId) {
    return false
  }

  if (filtros.dataInicial && reserva.data < filtros.dataInicial) {
    return false
  }

  if (filtros.dataFinal && reserva.data > filtros.dataFinal) {
    return false
  }

  return reservaCorrespondeBusca(reserva, filtros.busca)
}
