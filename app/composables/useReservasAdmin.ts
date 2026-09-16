import {
  mapReservaAdmin,
  type EventoReserva,
  type ReservaAdmin,
  type ReservaAdminBaseRow,
  type SolicitanteLookup,
  type TipoVeiculoAdmin,
  type VeiculoLookup
} from '@/utils/reservasAdmin'

interface SupabaseErrorLike {
  code?: string
  message?: string
}

export interface CancelarReservaResult {
  success: boolean
  error: string | null
}

const mapReservaError = (error: SupabaseErrorLike | null): string => {
  if (!error) {
    return 'Não foi possível concluir a operação. Tente novamente.'
  }

  if (error.code === '42501') {
    return 'Você não tem permissão para realizar esta ação.'
  }

  return error.message || 'Não foi possível concluir a operação. Tente novamente.'
}

export const useReservasAdmin = () => {
  const supabase = useSupabaseClient()

  const reservas = ref<ReservaAdmin[]>([])
  const tipos = ref<TipoVeiculoAdmin[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const loadingDetalhes = ref(false)
  const cancelandoId = ref<string | null>(null)

  const carregarTipos = async (): Promise<void> => {
    const { data, error: tiposError } = await supabase
      .from('tipos_veiculo_lavador')
      .select('id, descricao, tempo_min')
      .order('descricao', { ascending: true })

    if (tiposError) {
      error.value = mapReservaError(tiposError)
      return
    }

    tipos.value = (data as TipoVeiculoAdmin[] | null) ?? []
  }

  const carregarReservas = async (): Promise<void> => {
    loading.value = true
    error.value = null

    const { data, error: reservasError } = await supabase
      .from('reservas_lavagem')
      .select(
        'id, veiculo_id, solicitante_id, data_reserva, status, tempo_estimado, observacao, created_at, updated_at'
      )
      .order('data_reserva', { ascending: false })

    if (reservasError) {
      error.value = mapReservaError(reservasError)
      reservas.value = []
      loading.value = false
      return
    }

    const rows = (data as ReservaAdminBaseRow[] | null) ?? []
    const veiculoIds = [...new Set(rows.map((row) => row.veiculo_id))]
    const solicitanteIds = [
      ...new Set(rows.map((row) => row.solicitante_id).filter((id): id is string => !!id))
    ]
    const tiposMap = new Map(tipos.value.map((tipo) => [tipo.id, tipo]))

    let veiculosMap = new Map<string, VeiculoLookup>()
    let solicitantesMap = new Map<string, SolicitanteLookup>()

    if (veiculoIds.length > 0) {
      const { data: veiculosData, error: veiculosError } = await supabase
        .from('veiculos')
        .select('id, nome_frota, nr_placa_transport, ds_modelo, tipo_veiculo_id')
        .in('id', veiculoIds)

      if (veiculosError) {
        error.value = mapReservaError(veiculosError)
        reservas.value = []
        loading.value = false
        return
      }

      veiculosMap = new Map((veiculosData as VeiculoLookup[]).map((v) => [v.id, v]))
    }

    if (solicitanteIds.length > 0) {
      const { data: solicitantesData, error: solicitantesError } = await supabase
        .from('solicitantes_lavagem')
        .select('id, nome, matricula')
        .in('id', solicitanteIds)

      if (solicitantesError) {
        error.value = mapReservaError(solicitantesError)
        reservas.value = []
        loading.value = false
        return
      }

      solicitantesMap = new Map((solicitantesData as SolicitanteLookup[]).map((s) => [s.id, s]))
    }

    reservas.value = rows.map((row) =>
      mapReservaAdmin(row, veiculosMap, solicitantesMap, tiposMap)
    )
    loading.value = false
  }

  const carregar = async (): Promise<void> => {
    await carregarTipos()
    await carregarReservas()
  }

  const carregarEventos = async (reservaId: string): Promise<EventoReserva[]> => {
    loadingDetalhes.value = true

    const { data, error: eventosError } = await supabase
      .from('eventos_reserva')
      .select(
        'id, reserva_id, usuario_id, status_anterior, status_novo, tipo_evento, motivo, observacao, created_at'
      )
      .eq('reserva_id', reservaId)
      .order('created_at', { ascending: true })

    loadingDetalhes.value = false

    if (eventosError) {
      return []
    }

    return (data as EventoReserva[] | null) ?? []
  }

  const cancelarReserva = async (
    reservaId: string,
    observacao?: string
  ): Promise<CancelarReservaResult> => {
    cancelandoId.value = reservaId

    const { error: rpcError } = await supabase.rpc('cancelar_reserva_lavagem', {
      p_reserva_id: reservaId,
      p_observacao: observacao?.trim() || null
    })

    cancelandoId.value = null

    if (rpcError) {
      return { success: false, error: mapReservaError(rpcError) }
    }

    await carregarReservas()
    return { success: true, error: null }
  }

  return {
    reservas,
    tipos,
    loading,
    error,
    loadingDetalhes,
    cancelandoId,
    carregar,
    carregarReservas,
    carregarEventos,
    cancelarReserva
  }
}
