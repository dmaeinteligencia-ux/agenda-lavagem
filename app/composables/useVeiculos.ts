import {
  mapVeiculo,
  toVeiculoPayload,
  type TipoVeiculo,
  type Veiculo,
  type VeiculoBaseRow,
  type VeiculoFormData
} from '@/utils/veiculos'

const VEICULO_COLUMNS =
  'id, nome_frota, nr_placa_transport, ds_modelo, ds_combustivel, ano, tipo_veiculo_id, ativo, created_at, updated_at'

interface SupabaseErrorLike {
  code?: string
  message?: string
}

export interface VeiculoResult {
  success: boolean
  error: string | null
}

const mapVeiculoError = (error: SupabaseErrorLike | null): string => {
  if (!error) {
    return 'Não foi possível concluir a operação. Tente novamente.'
  }

  switch (error.code) {
    case '23505':
      return 'Já existe um veículo com esta placa.'
    case '23514':
      return 'A placa informada possui formato inválido.'
    case '23503':
      return 'O tipo de veículo selecionado é inválido.'
    case '42501':
      return 'Você não tem permissão para realizar esta ação.'
    default:
      return error.message || 'Não foi possível concluir a operação. Tente novamente.'
  }
}

export const useVeiculos = () => {
  const supabase = useSupabaseClient()

  const veiculos = ref<Veiculo[]>([])
  const tipos = ref<TipoVeiculo[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const saving = ref(false)
  const savingId = ref<string | null>(null)

  const carregarTipos = async (): Promise<void> => {
    const { data, error: tiposError } = await supabase
      .from('tipos_veiculo_lavador')
      .select('id, descricao, tempo_min')
      .order('descricao', { ascending: true })

    if (tiposError) {
      error.value = mapVeiculoError(tiposError)
      return
    }

    tipos.value = (data as TipoVeiculo[] | null) ?? []
  }

  const carregarVeiculos = async (): Promise<void> => {
    loading.value = true
    error.value = null

    const { data, error: veiculosError } = await supabase
      .from('veiculos')
      .select(VEICULO_COLUMNS)
      .order('nome_frota', { ascending: true, nullsFirst: false })

    if (veiculosError) {
      error.value = mapVeiculoError(veiculosError)
      veiculos.value = []
      loading.value = false
      return
    }

    veiculos.value = ((data as VeiculoBaseRow[] | null) ?? []).map((row) =>
      mapVeiculo(row, tipos.value)
    )
    loading.value = false
  }

  const carregar = async (): Promise<void> => {
    await carregarTipos()
    await carregarVeiculos()
  }

  const criarVeiculo = async (data: VeiculoFormData): Promise<VeiculoResult> => {
    saving.value = true

    const { error: insertError } = await supabase
      .from('veiculos')
      .insert(toVeiculoPayload(data))

    saving.value = false

    if (insertError) {
      return { success: false, error: mapVeiculoError(insertError) }
    }

    await carregarVeiculos()
    return { success: true, error: null }
  }

  const atualizarVeiculo = async (id: string, data: VeiculoFormData): Promise<VeiculoResult> => {
    saving.value = true

    const { error: updateError } = await supabase
      .from('veiculos')
      .update(toVeiculoPayload(data))
      .eq('id', id)

    saving.value = false

    if (updateError) {
      return { success: false, error: mapVeiculoError(updateError) }
    }

    await carregarVeiculos()
    return { success: true, error: null }
  }

  const alterarAtivo = async (id: string, ativo: boolean): Promise<VeiculoResult> => {
    savingId.value = id

    const { error: updateError } = await supabase
      .from('veiculos')
      .update({ ativo })
      .eq('id', id)

    savingId.value = null

    if (updateError) {
      return { success: false, error: mapVeiculoError(updateError) }
    }

    await carregarVeiculos()
    return { success: true, error: null }
  }

  return {
    veiculos,
    tipos,
    loading,
    error,
    saving,
    savingId,
    carregar,
    carregarTipos,
    carregarVeiculos,
    criarVeiculo,
    atualizarVeiculo,
    alterarAtivo
  }
}
