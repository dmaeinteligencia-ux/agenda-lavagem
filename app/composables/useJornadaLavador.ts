import type { JornadaLavador, JornadaLavadorFormData } from '@/utils/jornadaLavador'

interface SupabaseErrorLike {
  code?: string
  message?: string
}

export interface JornadaResult {
  success: boolean
  error: string | null
}

const JORNADA_COLUMNS = 'id, regime, horas_disponiveis, created_at, updated_at'

const mapJornadaError = (error: SupabaseErrorLike | null): string => {
  if (!error) {
    return 'Não foi possível concluir a operação. Tente novamente.'
  }

  if (error.code === '42501') {
    return 'Você não possui permissão para realizar esta operação.'
  }

  return 'Não foi possível salvar a jornada. Tente novamente.'
}

export const useJornadaLavador = () => {
  const supabase = useSupabaseClient()

  const jornadas = ref<JornadaLavador[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const salvandoId = ref<string | null>(null)

  const carregar = async (): Promise<void> => {
    loading.value = true
    error.value = null

    const { data, error: carregarError } = await supabase
      .from('jornadas_lavador')
      .select(JORNADA_COLUMNS)
      .order('regime', { ascending: true })

    loading.value = false

    if (carregarError) {
      error.value = 'Não foi possível carregar as jornadas.'
      jornadas.value = []
      return
    }

    jornadas.value = (data as JornadaLavador[] | null) ?? []
  }

  const atualizarJornada = async (
    id: string,
    data: JornadaLavadorFormData
  ): Promise<JornadaResult> => {
    salvandoId.value = id

    const { data: atualizada, error: updateError } = await supabase
      .from('jornadas_lavador')
      .update({ horas_disponiveis: data.horas_disponiveis })
      .eq('id', id)
      .select(JORNADA_COLUMNS)
      .single()

    salvandoId.value = null

    if (updateError) {
      return { success: false, error: mapJornadaError(updateError) }
    }

    const index = jornadas.value.findIndex((jornada) => jornada.id === id)
    if (index !== -1 && atualizada) {
      jornadas.value[index] = atualizada as JornadaLavador
    }

    return { success: true, error: null }
  }

  return {
    jornadas,
    loading,
    error,
    salvandoId,
    carregar,
    atualizarJornada
  }
}
