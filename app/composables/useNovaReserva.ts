import { toISODate } from '@/utils/reservas'

export interface SolicitanteBusca {
  id: string
  matricula: string
  nome: string
}

export interface VeiculoBusca {
  id: string
  nome_frota: string | null
  ds_modelo: string | null
  ds_combustivel: string | null
  ano: number | null
  nr_placa_transport: string
  tipo_veiculo_id: string | null
  tipo_veiculo_descricao: string | null
  ativo: boolean
}

export interface DisponibilidadeDia {
  data_reserva: string
  regime: string
  capacidade_minutos: number
  reservado_minutos: number
  disponivel_minutos: number
  tempo_veiculo_minutos: number
  veiculo_tem_reserva: boolean
  disponivel: boolean
}

export interface ReservaCriada {
  id: string
  solicitante_id: string
  veiculo_id: string
  data_reserva: string
  status: string
  tempo_estimado: number
  observacao: string | null
}

export interface BuscarSolicitanteResult {
  success: boolean
  message: string | null
  naoEncontrado: boolean
}

export interface CadastrarSolicitanteResult {
  success: boolean
  message: string | null
}

interface SupabaseErrorLike {
  code?: string
  message?: string
}

const mapCadastroSolicitanteError = (err: SupabaseErrorLike | null): string => {
  if (!err) {
    return 'Não foi possível cadastrar o solicitante.'
  }

  switch (err.code) {
    case '23505':
      return 'Já existe um solicitante cadastrado com esta matrícula.'
    case '22023':
      return 'Dados inválidos. Verifique nome, matrícula e telefone.'
    case '42501':
      return 'Operação não permitida.'
    default:
      return 'Não foi possível cadastrar o solicitante.'
  }
}

export const useNovaReserva = () => {
  const supabase = useSupabaseClient()

  const solicitante = ref<SolicitanteBusca | null>(null)
  const veiculo = ref<VeiculoBusca | null>(null)
  const dataReserva = ref<string>(toISODate(new Date()))
  const disponibilidade = ref<DisponibilidadeDia | null>(null)
  const reservaCriada = ref<ReservaCriada | null>(null)

  const buscandoSolicitante = ref(false)
  const buscandoVeiculo = ref(false)
  const consultandoDisponibilidade = ref(false)
  const criandoReserva = ref(false)
  const cadastrandoSolicitante = ref(false)

  const error = ref<string | null>(null)

  const buscarSolicitante = async (matricula: string): Promise<BuscarSolicitanteResult> => {
    buscandoSolicitante.value = true
    error.value = null
    solicitante.value = null

    try {
      const { data, error: rpcError } = await supabase.rpc('buscar_solicitante_por_matricula', {
        p_matricula: matricula.trim()
      })

      if (rpcError) {
        return {
          success: false,
          message: rpcError.message || 'Não foi possível buscar o solicitante.',
          naoEncontrado: false
        }
      }

      const linha = (data as SolicitanteBusca[])?.[0]
      if (!linha) {
        return { success: false, message: null, naoEncontrado: true }
      }

      solicitante.value = linha
      return { success: true, message: null, naoEncontrado: false }
    } finally {
      buscandoSolicitante.value = false
    }
  }

  const cadastrarSolicitante = async (
    nome: string,
    matricula: string,
    telefone: string
  ): Promise<CadastrarSolicitanteResult> => {
    cadastrandoSolicitante.value = true

    try {
      const { data, error: rpcError } = await supabase.rpc('cadastrar_solicitante_publico', {
        p_nome: nome.trim(),
        p_matricula: matricula.trim(),
        p_telefone: telefone.trim()
      })

      if (rpcError) {
        return { success: false, message: mapCadastroSolicitanteError(rpcError) }
      }

      const linha = (data as SolicitanteBusca[])?.[0]
      if (!linha) {
        return { success: false, message: 'Não foi possível cadastrar o solicitante.' }
      }

      solicitante.value = { id: linha.id, matricula: linha.matricula, nome: linha.nome }
      return { success: true, message: null }
    } finally {
      cadastrandoSolicitante.value = false
    }
  }

  const buscarVeiculo = async (placa: string): Promise<{ success: boolean; message: string | null }> => {
    buscandoVeiculo.value = true
    error.value = null
    veiculo.value = null
    disponibilidade.value = null

    try {
      const { data, error: rpcError } = await supabase.rpc('buscar_veiculo_por_placa', {
        p_placa: placa.trim()
      })

      if (rpcError) {
        return { success: false, message: rpcError.message || 'Não foi possível buscar o veículo.' }
      }

      const linha = (data as VeiculoBusca[])?.[0]
      if (!linha) {
        return { success: false, message: 'Veículo não encontrado.' }
      }

      veiculo.value = linha
      return { success: true, message: null }
    } finally {
      buscandoVeiculo.value = false
    }
  }

  const consultarDisponibilidade = async (): Promise<{ success: boolean; message: string | null }> => {
    if (!veiculo.value || !dataReserva.value) {
      return { success: false, message: 'Informe o veículo e a data.' }
    }

    consultandoDisponibilidade.value = true
    error.value = null
    disponibilidade.value = null

    try {
      const { data, error: rpcError } = await supabase.rpc('consultar_disponibilidade_publica', {
        p_veiculo_id: veiculo.value.id,
        p_data: dataReserva.value
      })

      if (rpcError) {
        return { success: false, message: rpcError.message || 'Não foi possível consultar a disponibilidade.' }
      }

      const linha = (data as DisponibilidadeDia[])?.[0]
      if (!linha) {
        return { success: false, message: 'Não foi possível consultar a disponibilidade.' }
      }

      disponibilidade.value = linha
      return { success: true, message: null }
    } finally {
      consultandoDisponibilidade.value = false
    }
  }

  const criarReserva = async (observacao?: string): Promise<{ success: boolean; message: string | null }> => {
    if (!solicitante.value || !veiculo.value || !dataReserva.value) {
      return { success: false, message: 'Preencha todos os campos obrigatórios.' }
    }

    criandoReserva.value = true
    error.value = null

    try {
      const { data, error: rpcError } = await supabase.rpc('criar_reserva_lavagem', {
        p_solicitante_id: solicitante.value.id,
        p_veiculo_id: veiculo.value.id,
        p_data: dataReserva.value,
        p_observacao: observacao?.trim() || null
      })

      if (rpcError) {
        return { success: false, message: rpcError.message || 'Não foi possível criar a reserva.' }
      }

      const linha = (data as ReservaCriada[])?.[0]
      if (!linha) {
        return { success: false, message: 'Não foi possível criar a reserva.' }
      }

      reservaCriada.value = linha
      return { success: true, message: null }
    } finally {
      criandoReserva.value = false
    }
  }

  const resetNovaReserva = () => {
    solicitante.value = null
    veiculo.value = null
    dataReserva.value = toISODate(new Date())
    disponibilidade.value = null
    reservaCriada.value = null
    error.value = null
  }

  return {
    solicitante,
    veiculo,
    dataReserva,
    disponibilidade,
    reservaCriada,
    buscandoSolicitante,
    buscandoVeiculo,
    consultandoDisponibilidade,
    criandoReserva,
    cadastrandoSolicitante,
    error,
    buscarSolicitante,
    cadastrarSolicitante,
    buscarVeiculo,
    consultarDisponibilidade,
    criarReserva,
    resetNovaReserva
  }
}
