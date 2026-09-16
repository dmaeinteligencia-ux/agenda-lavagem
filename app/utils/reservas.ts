import type { Perfil } from '@/utils/accessControl'

export type ReservaStatus =
  | 'RESERVADA'
  | 'EM_LAVAGEM'
  | 'CONCLUIDA'
  | 'CANCELADA'
  | 'EXPIRADA'
  | 'NAO_COMPARECEU'
  | 'NAO_ATENDIDA'
  | 'NAO_CONCLUIDA'

export interface ReservaComRelacionamentos {
  id: string
  data_reserva: string
  status: ReservaStatus
  tempo_estimado: number
  observacao: string | null
  created_at: string
  veiculo_id: string
  solicitante_id: string | null
  veiculoNomeFrota: string | null
  veiculoPlaca: string
  veiculoModelo: string | null
  tipoVeiculo: string | null
  solicitanteNome: string | null
  solicitanteMatricula: string | null
}

export interface EventoOperacional {
  reserva_id: string
  tipo_evento: string
  status_anterior: string | null
  status_novo: string
  created_at: string
}

export interface HorariosReserva {
  inicioRaw: string | null
  fimRaw: string | null
}

export interface AgendaReservaItem {
  id: string
  vehicle: string
  plate: string
  type: string
  status: ReservaStatus
  duration: number
  solicitante: string
  matricula: string
  inicioLavagem: string | null
  fimLavagem: string | null
}

export interface CapacidadeDia {
  regime: string
  capacidadeMinutos: number
  reservadoMinutos: number
  disponivelMinutos: number
}

export const STATUS_LABELS: Record<ReservaStatus, string> = {
  RESERVADA: 'Reservada',
  EM_LAVAGEM: 'Em lavagem',
  CONCLUIDA: 'Concluída',
  CANCELADA: 'Cancelada',
  EXPIRADA: 'Expirada',
  NAO_COMPARECEU: 'Não compareceu',
  NAO_ATENDIDA: 'Não atendida',
  NAO_CONCLUIDA: 'Não concluída'
}

export function toISODate(d: Date): string {
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const dia = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${dia}`
}

export function addDays(iso: string, delta: number): string {
  const [y, m, d] = iso.split('-').map(Number)
  const date = new Date(y, m - 1, d)
  date.setDate(date.getDate() + delta)
  return toISODate(date)
}

export function formatarDataExtensa(iso: string): string {
  const [ano, mes, dia] = iso.split('-').map(Number)
  const meses = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
  ]
  return `${dia} de ${meses[mes - 1]} de ${ano}`
}

export function formatarHora(iso: string | null): string | null {
  if (!iso) {
    return null
  }
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) {
    return null
  }
  const hh = String(d.getHours()).padStart(2, '0')
  const mm = String(d.getMinutes()).padStart(2, '0')
  return `${hh}:${mm}`
}

export function mapReservaToAgendaItem(
  reserva: ReservaComRelacionamentos,
  horarios: HorariosReserva | undefined
): AgendaReservaItem {
  return {
    id: reserva.id,
    vehicle: reserva.veiculoNomeFrota || reserva.veiculoModelo || '—',
    plate: reserva.veiculoPlaca,
    type: reserva.tipoVeiculo || '—',
    status: reserva.status,
    duration: reserva.tempo_estimado,
    solicitante: reserva.solicitanteNome || '—',
    matricula: reserva.solicitanteMatricula || '—',
    inicioLavagem: formatarHora(horarios?.inicioRaw ?? null),
    fimLavagem: formatarHora(horarios?.fimRaw ?? null)
  }
}

export type AcaoChave =
  | 'iniciar'
  | 'concluir'
  | 'cancelar'
  | 'nao_comparecimento'
  | 'nao_atendimento'
  | 'nao_conclusao'

export interface MotivoOpcao {
  value: string
  label: string
}

export const motivosNaoAtendimento: MotivoOpcao[] = [
  { value: 'ATRASO_LAVAGENS_ANTERIORES', label: 'Atraso nas lavagens anteriores' },
  { value: 'FIM_DA_JORNADA', label: 'Fim da jornada' },
  { value: 'INDISPONIBILIDADE_LAVADOR', label: 'Indisponibilidade do lavador' },
  { value: 'FALTA_AGUA', label: 'Falta de água' },
  { value: 'FALHA_EQUIPAMENTO', label: 'Falha de equipamento' },
  { value: 'PROBLEMA_ESTRUTURAL', label: 'Problema de infraestrutura' },
  { value: 'PRIORIDADE_OPERACIONAL', label: 'Atendimento de demanda prioritária' },
  { value: 'OUTRO', label: 'Outro motivo' }
]

export const motivosNaoConclusao: MotivoOpcao[] = [
  { value: 'FIM_DA_JORNADA', label: 'Fim da jornada' },
  { value: 'INDISPONIBILIDADE_LAVADOR', label: 'Indisponibilidade do lavador' },
  { value: 'FALTA_AGUA', label: 'Falta de água' },
  { value: 'FALHA_EQUIPAMENTO', label: 'Falha de equipamento' },
  { value: 'PROBLEMA_ESTRUTURAL', label: 'Problema de infraestrutura' },
  { value: 'PRIORIDADE_OPERACIONAL', label: 'Atendimento de demanda prioritária' },
  { value: 'OUTRO', label: 'Outro motivo' }
]

export interface AcaoReserva {
  chave: AcaoChave
  label: string
  variante: 'default' | 'danger' | 'warning'
}

export function acoesParaReserva(
  status: ReservaStatus,
  perfil: Perfil | null,
  temAcesso: boolean
): AcaoReserva[] {
  if (!temAcesso || !perfil) {
    return []
  }

  const operacional = perfil === 'ADMIN' || perfil === 'LAVADOR'
  const admin = perfil === 'ADMIN'

  switch (status) {
    case 'RESERVADA': {
      if (!operacional) {
        return []
      }
      const acoes: AcaoReserva[] = [
        { chave: 'iniciar', label: 'Iniciar lavagem', variante: 'default' },
        { chave: 'nao_comparecimento', label: 'Não compareceu', variante: 'warning' },
        { chave: 'nao_atendimento', label: 'Não atendida', variante: 'warning' }
      ]
      if (admin) {
        acoes.push({ chave: 'cancelar', label: 'Cancelar', variante: 'danger' })
      }
      return acoes
    }
    case 'EM_LAVAGEM': {
      if (!operacional) {
        return []
      }
      return [
        { chave: 'concluir', label: 'Concluir lavagem', variante: 'default' },
        { chave: 'nao_conclusao', label: 'Não concluída', variante: 'warning' }
      ]
    }
    default:
      return []
  }
}

export function mapAcaoError(message: string | null): string {
  if (!message) {
    return 'Não foi possível concluir a operação.'
  }
  if (message.includes('Acesso não autorizado')) {
    return 'Você não tem permissão para realizar esta ação.'
  }
  if (message.includes('observação é obrigatória')) {
    return 'Informe a observação para o motivo Outro.'
  }
  if (message.includes('Motivo obrigatório')) {
    return 'Selecione um motivo.'
  }
  return message
}

export interface NovaReservaVehicle {
  identification: string
  plate: string
  type: string
  model: string
}

export interface NovaReservaCapacity {
  total: string
  used: string
  available: string
}
