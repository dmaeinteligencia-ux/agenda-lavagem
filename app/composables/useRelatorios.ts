import {
  mapReservaAdmin,
  type EventoReserva,
  type ReservaAdmin,
  type ReservaAdminBaseRow,
  type SolicitanteLookup,
  type TipoVeiculoAdmin,
  type VeiculoLookup
} from '@/utils/reservasAdmin'
import { montarLinhas, type RelatorioLinha } from '@/utils/relatorios'

interface SupabaseErrorLike {
  code?: string
  message?: string
}

export interface GerarRelatorioResult {
  success: boolean
  error: string | null
  linhas: RelatorioLinha[]
}

const mapRelatorioError = (error: SupabaseErrorLike | null): string => {
  if (!error) {
    return 'Não foi possível gerar o relatório. Tente novamente.'
  }

  if (error.code === '42501') {
    return 'Você não tem permissão para acessar estes dados.'
  }

  return error.message || 'Não foi possível gerar o relatório. Tente novamente.'
}

export const useRelatorios = () => {
  const supabase = useSupabaseClient()

  const tipos = ref<TipoVeiculoAdmin[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const carregarTipos = async (): Promise<void> => {
    const { data, error: tiposError } = await supabase
      .from('tipos_veiculo_lavador')
      .select('id, descricao, tempo_min')
      .order('descricao', { ascending: true })

    if (tiposError) {
      error.value = mapRelatorioError(tiposError)
      return
    }

    tipos.value = (data as TipoVeiculoAdmin[] | null) ?? []
  }

  const carregarEventos = async (
    reservaIds: string[]
  ): Promise<Map<string, EventoReserva[]>> => {
    const mapa = new Map<string, EventoReserva[]>()

    if (reservaIds.length === 0) {
      return mapa
    }

    const { data, error: eventosError } = await supabase
      .from('eventos_reserva')
      .select(
        'id, reserva_id, usuario_id, status_anterior, status_novo, tipo_evento, motivo, observacao, created_at'
      )
      .in('reserva_id', reservaIds)
      .order('created_at', { ascending: true })

    if (eventosError) {
      throw eventosError
    }

    for (const evento of (data as EventoReserva[] | null) ?? []) {
      const lista = mapa.get(evento.reserva_id) ?? []
      lista.push(evento)
      mapa.set(evento.reserva_id, lista)
    }

    return mapa
  }

  const gerar = async (
    dataInicial: string,
    dataFinal: string
  ): Promise<GerarRelatorioResult> => {
    loading.value = true
    error.value = null

    try {
      const { data, error: reservasError } = await supabase
        .from('reservas_lavagem')
        .select(
          'id, veiculo_id, solicitante_id, data_reserva, status, tempo_estimado, observacao, created_at, updated_at'
        )
        .gte('data_reserva', dataInicial)
        .lte('data_reserva', dataFinal)
        .order('data_reserva', { ascending: true })

      if (reservasError) {
        throw reservasError
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
          .select('id, nome_frota, nr_placa_transport, ds_modelo, tipo_veiculo_id, ativo')
          .in('id', veiculoIds)

        if (veiculosError) {
          throw veiculosError
        }

        veiculosMap = new Map((veiculosData as VeiculoLookup[]).map((v) => [v.id, v]))
      }

      if (solicitanteIds.length > 0) {
        const { data: solicitantesData, error: solicitantesError } = await supabase
          .from('solicitantes_lavagem')
          .select('id, nome, matricula')
          .in('id', solicitanteIds)

        if (solicitantesError) {
          throw solicitantesError
        }

        solicitantesMap = new Map(
          (solicitantesData as SolicitanteLookup[]).map((s) => [s.id, s])
        )
      }

      const reservas: ReservaAdmin[] = rows.map((row) =>
        mapReservaAdmin(row, veiculosMap, solicitantesMap, tiposMap)
      )

      const eventosPorReserva = await carregarEventos(reservas.map((reserva) => reserva.id))

      loading.value = false
      return { success: true, error: null, linhas: montarLinhas(reservas, eventosPorReserva) }
    } catch (err) {
      const mensagem = mapRelatorioError(err as SupabaseErrorLike)
      error.value = mensagem
      loading.value = false
      return { success: false, error: mensagem, linhas: [] }
    }
  }

  return {
    tipos,
    loading,
    error,
    carregarTipos,
    gerar
  }
}
