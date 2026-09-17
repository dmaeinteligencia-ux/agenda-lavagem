import type { TipoVeiculo, TipoVeiculoFormData } from '@/utils/tiposVeiculo'

interface SupabaseErrorLike {
  code?: string
  message?: string
}

export interface TipoVeiculoResult {
  success: boolean
  error: string | null
}

const TIPO_COLUMNS = 'id, descricao, tempo_min, created_at, updated_at'

const mapTipoError = (error: SupabaseErrorLike | null): string => {
  if (!error) {
    return 'Não foi possível concluir a operação. Tente novamente.'
  }

  switch (error.code) {
    case '23505':
      return 'Já existe um tipo de veículo com esta descrição.'
    case '23514':
      return 'O tempo de lavagem informado é inválido.'
    case '23503':
      return 'Este tipo não pode ser excluído porque está vinculado a um ou mais veículos.'
    case '42501':
      return 'Você não possui permissão para realizar esta operação.'
    default:
      return error.message || 'Não foi possível concluir a operação. Tente novamente.'
  }
}

export const useTiposVeiculo = () => {
  const supabase = useSupabaseClient()

  const tipos = ref<TipoVeiculo[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const salvando = ref(false)
  const excluindoId = ref<string | null>(null)

  const ordenar = () => {
    tipos.value = [...tipos.value].sort((a, b) =>
      a.descricao.localeCompare(b.descricao, 'pt-BR')
    )
  }

  const carregar = async (): Promise<void> => {
    loading.value = true
    error.value = null

    const { data, error: carregarError } = await supabase
      .from('tipos_veiculo_lavador')
      .select(TIPO_COLUMNS)
      .order('descricao', { ascending: true })

    loading.value = false

    if (carregarError) {
      error.value = 'Não foi possível carregar os tipos de veículo.'
      tipos.value = []
      return
    }

    tipos.value = (data as TipoVeiculo[] | null) ?? []
  }

  const criarTipo = async (data: TipoVeiculoFormData): Promise<TipoVeiculoResult> => {
    salvando.value = true

    const { data: criado, error: insertError } = await supabase
      .from('tipos_veiculo_lavador')
      .insert({
        descricao: data.descricao.trim(),
        tempo_min: data.tempo_min
      })
      .select(TIPO_COLUMNS)
      .single()

    salvando.value = false

    if (insertError) {
      return { success: false, error: mapTipoError(insertError) }
    }

    if (criado) {
      tipos.value = [...tipos.value, criado as TipoVeiculo]
      ordenar()
    }

    return { success: true, error: null }
  }

  const atualizarTipo = async (
    id: string,
    data: TipoVeiculoFormData
  ): Promise<TipoVeiculoResult> => {
    salvando.value = true

    const { data: atualizado, error: updateError } = await supabase
      .from('tipos_veiculo_lavador')
      .update({
        descricao: data.descricao.trim(),
        tempo_min: data.tempo_min
      })
      .eq('id', id)
      .select(TIPO_COLUMNS)
      .single()

    salvando.value = false

    if (updateError) {
      return { success: false, error: mapTipoError(updateError) }
    }

    const index = tipos.value.findIndex((tipo) => tipo.id === id)
    if (index !== -1 && atualizado) {
      tipos.value[index] = atualizado as TipoVeiculo
      ordenar()
    }

    return { success: true, error: null }
  }

  const excluirTipo = async (id: string): Promise<TipoVeiculoResult> => {
    excluindoId.value = id

    const { error: deleteError } = await supabase
      .from('tipos_veiculo_lavador')
      .delete()
      .eq('id', id)

    excluindoId.value = null

    if (deleteError) {
      return { success: false, error: mapTipoError(deleteError) }
    }

    tipos.value = tipos.value.filter((tipo) => tipo.id !== id)
    return { success: true, error: null }
  }

  return {
    tipos,
    loading,
    error,
    salvando,
    excluindoId,
    carregar,
    criarTipo,
    atualizarTipo,
    excluirTipo
  }
}
