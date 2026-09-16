import {
  addDays,
  mapAcaoError,
  toISODate,
  type CapacidadeDia,
  type EventoOperacional,
  type HorariosReserva,
  type ReservaComRelacionamentos
} from '@/utils/reservas'

interface VeiculoRow {
  id: string
  nr_placa_transport: string
  ds_modelo: string | null
  nome_frota: string | null
  tipo_veiculo_id: string | null
}

interface SolicitanteRow {
  id: string
  nome: string
  matricula: string
}

interface TipoVeiculoRow {
  id: string
  descricao: string
}

interface DisponibilidadeRow {
  data_reserva: string
  regime: string
  capacidade_minutos: number
  reservado_minutos: number
  disponivel_minutos: number
  tempo_veiculo_minutos: number
  veiculo_tem_reserva: boolean
  disponivel: boolean
}

export const useReservas = () => {
  const supabase = useSupabaseClient()

  const selectedDate = ref<string>(toISODate(new Date()))
  const reservas = ref<ReservaComRelacionamentos[]>([])
  const horarios = ref<Map<string, HorariosReserva>>(new Map())
  const capacidade = ref<CapacidadeDia | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const fetchReservas = async () => {
    loading.value = true
    error.value = null

    try {
      const { data: reservasData, error: reservasError } = await supabase
        .from('reservas_lavagem')
        .select('id, veiculo_id, solicitante_id, data_reserva, status, tempo_estimado, observacao, created_at')
        .eq('data_reserva', selectedDate.value)
        .order('created_at', { ascending: true })

      if (reservasError) {
        throw reservasError
      }

      const lista = (reservasData ?? []) as {
        id: string
        veiculo_id: string
        solicitante_id: string | null
        data_reserva: string
        status: string
        tempo_estimado: number
        observacao: string | null
        created_at: string
      }[]

      const veiculoIds = [...new Set(lista.map((r) => r.veiculo_id))]
      const solicitanteIds = [...new Set(lista.filter((r) => r.solicitante_id).map((r) => r.solicitante_id as string))]

      let veiculosMap = new Map<string, VeiculoRow>()
      let solicitantesMap = new Map<string, SolicitanteRow>()
      let tiposMap = new Map<string, TipoVeiculoRow>()

      if (veiculoIds.length > 0) {
        const { data: veiculosData, error: veiculosError } = await supabase
          .from('veiculos')
          .select('id, nr_placa_transport, ds_modelo, nome_frota, tipo_veiculo_id')
          .in('id', veiculoIds)

        if (veiculosError) {
          throw veiculosError
        }

        veiculosMap = new Map((veiculosData as VeiculoRow[]).map((v) => [v.id, v]))
      }

      if (solicitanteIds.length > 0) {
        const { data: solicitantesData, error: solicitantesError } = await supabase
          .from('solicitantes_lavagem')
          .select('id, nome, matricula')
          .in('id', solicitanteIds)

        if (solicitantesError) {
          throw solicitantesError
        }

        solicitantesMap = new Map((solicitantesData as SolicitanteRow[]).map((s) => [s.id, s]))
      }

      const { data: tiposData, error: tiposError } = await supabase
        .from('tipos_veiculo_lavador')
        .select('id, descricao')

      if (tiposError) {
        throw tiposError
      }

      tiposMap = new Map((tiposData as TipoVeiculoRow[]).map((t) => [t.id, t]))

      reservas.value = lista.map((r) => {
        const veiculo = veiculosMap.get(r.veiculo_id)
        const solicitante = r.solicitante_id ? solicitantesMap.get(r.solicitante_id) : undefined
        const tipo = veiculo?.tipo_veiculo_id ? tiposMap.get(veiculo.tipo_veiculo_id) : undefined

        return {
          id: r.id,
          data_reserva: r.data_reserva,
          status: r.status as ReservaComRelacionamentos['status'],
          tempo_estimado: r.tempo_estimado,
          observacao: r.observacao,
          created_at: r.created_at,
          veiculo_id: r.veiculo_id,
          solicitante_id: r.solicitante_id,
          veiculoNomeFrota: veiculo?.nome_frota ?? null,
          veiculoPlaca: veiculo?.nr_placa_transport ?? '—',
          veiculoModelo: veiculo?.ds_modelo ?? null,
          tipoVeiculo: tipo?.descricao ?? null,
          solicitanteNome: solicitante?.nome ?? null,
          solicitanteMatricula: solicitante?.matricula ?? null
        }
      })

      await carregarEventos(lista.map((r) => r.id))
      await carregarCapacidade(veiculoIds)
    } catch (err) {
      error.value = 'Não foi possível carregar a agenda.'
      console.error('Erro ao carregar agenda:', err)
    } finally {
      loading.value = false
    }
  }

  const carregarEventos = async (reservaIds: string[]) => {
    const novoMapa = new Map<string, HorariosReserva>()

    if (reservaIds.length > 0) {
      const { data: eventosData, error: eventosError } = await supabase
        .from('eventos_reserva')
        .select('reserva_id, tipo_evento, status_anterior, status_novo, created_at')
        .in('reserva_id', reservaIds)
        .in('tipo_evento', ['ALTERACAO_STATUS', 'NAO_CONCLUSAO'])
        .order('created_at', { ascending: true })

      if (eventosError) {
        throw eventosError
      }

      for (const ev of eventosData as EventoOperacional[]) {
        const atual = novoMapa.get(ev.reserva_id) ?? { inicioRaw: null, fimRaw: null }

        if (ev.status_anterior === 'RESERVADA' && ev.status_novo === 'EM_LAVAGEM') {
          atual.inicioRaw = ev.created_at
        } else if (ev.status_anterior === 'EM_LAVAGEM' && ev.status_novo === 'CONCLUIDA') {
          atual.fimRaw = ev.created_at
        } else if (ev.tipo_evento === 'NAO_CONCLUSAO') {
          atual.fimRaw = ev.created_at
        }

        novoMapa.set(ev.reserva_id, atual)
      }
    }

    horarios.value = novoMapa
  }

  const carregarCapacidade = async (veiculoIds: string[]) => {
    capacidade.value = null

    let capacidadeVeiculoId: string | null = veiculoIds[0] ?? null

    if (!capacidadeVeiculoId) {
      const { data: qualquerVeiculo } = await supabase
        .from('veiculos')
        .select('id')
        .limit(1)

      capacidadeVeiculoId = (qualquerVeiculo?.[0] as { id: string } | undefined)?.id ?? null
    }

    if (!capacidadeVeiculoId) {
      return
    }

    const { data: dispData, error: dispError } = await supabase.rpc('consultar_disponibilidade', {
      p_veiculo_id: capacidadeVeiculoId,
      p_data: selectedDate.value
    })

    if (dispError) {
      return
    }

    const linhas = dispData as DisponibilidadeRow[]
    if (linhas && linhas.length > 0) {
      const l = linhas[0]
      capacidade.value = {
        regime: l.regime,
        capacidadeMinutos: l.capacidade_minutos,
        reservadoMinutos: l.reservado_minutos,
        disponivelMinutos: l.disponivel_minutos
      }
    }
  }

  const setDate = async (iso: string) => {
    selectedDate.value = iso
    await fetchReservas()
  }

  const goPrev = async () => {
    selectedDate.value = addDays(selectedDate.value, -1)
    await fetchReservas()
  }

  const goNext = async () => {
    selectedDate.value = addDays(selectedDate.value, 1)
    await fetchReservas()
  }

  const goToday = async () => {
    selectedDate.value = toISODate(new Date())
    await fetchReservas()
  }

  const iniciarLavagem = async (reservaId: string, observacao?: string) => {
    const { error } = await supabase.rpc('iniciar_lavagem', {
      p_reserva_id: reservaId,
      p_observacao: observacao?.trim() || null
    })
    return { success: !error, message: error ? mapAcaoError(error.message ?? null) : null }
  }

  const concluirLavagem = async (reservaId: string, observacao?: string) => {
    const { error } = await supabase.rpc('concluir_lavagem', {
      p_reserva_id: reservaId,
      p_observacao: observacao?.trim() || null
    })
    return { success: !error, message: error ? mapAcaoError(error.message ?? null) : null }
  }

  const cancelarReserva = async (reservaId: string, observacao?: string) => {
    const { error } = await supabase.rpc('cancelar_reserva_lavagem', {
      p_reserva_id: reservaId,
      p_observacao: observacao?.trim() || null
    })
    return { success: !error, message: error ? mapAcaoError(error.message ?? null) : null }
  }

  const registrarNaoComparecimento = async (reservaId: string, observacao?: string) => {
    const { error } = await supabase.rpc('registrar_nao_comparecimento', {
      p_reserva_id: reservaId,
      p_observacao: observacao?.trim() || null
    })
    return { success: !error, message: error ? mapAcaoError(error.message ?? null) : null }
  }

  const registrarNaoAtendimento = async (reservaId: string, motivo: string, observacao?: string) => {
    const { error } = await supabase.rpc('registrar_nao_atendimento', {
      p_reserva_id: reservaId,
      p_motivo: motivo,
      p_observacao: observacao?.trim() || null
    })
    return { success: !error, message: error ? mapAcaoError(error.message ?? null) : null }
  }

  const registrarNaoConclusao = async (reservaId: string, motivo: string, observacao?: string) => {
    const { error } = await supabase.rpc('registrar_nao_conclusao', {
      p_reserva_id: reservaId,
      p_motivo: motivo,
      p_observacao: observacao?.trim() || null
    })
    return { success: !error, message: error ? mapAcaoError(error.message ?? null) : null }
  }

  return {
    selectedDate,
    reservas,
    horarios,
    capacidade,
    loading,
    error,
    fetchReservas,
    setDate,
    goPrev,
    goNext,
    goToday,
    iniciarLavagem,
    concluirLavagem,
    cancelarReserva,
    registrarNaoComparecimento,
    registrarNaoAtendimento,
    registrarNaoConclusao
  }
}
