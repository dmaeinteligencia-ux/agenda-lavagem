import {
  intervaloMes,
  type CalendarioConfiguracao,
  type CalendarioOperacionalFormData,
  type FeriadoOficial
} from '@/utils/calendarioOperacional'

interface SupabaseErrorLike {
  code?: string
  message?: string
}

export interface CalendarioResult {
  success: boolean
  error: string | null
}

const mapCalendarioError = (error: SupabaseErrorLike | null): string => {
  if (!error) {
    return 'Não foi possível concluir a operação. Tente novamente.'
  }

  switch (error.code) {
    case '23505':
      return 'Já existe uma configuração para esta data.'
    case '23514':
      return 'Valores inválidos para a configuração.'
    case '42501':
      return 'Você não tem permissão para realizar esta ação.'
    default:
      return error.message || 'Não foi possível concluir a operação. Tente novamente.'
  }
}

export const useCalendarioOperacional = () => {
  const supabase = useSupabaseClient()

  const configuracoes = ref<CalendarioConfiguracao[]>([])
  const feriados = ref<FeriadoOficial[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const saving = ref(false)

  const carregarMes = async (ano: number, mes: number): Promise<void> => {
    loading.value = true
    error.value = null

    const { inicio, fim } = intervaloMes(ano, mes)

    const [configRes, feriadosRes] = await Promise.all([
      supabase
        .from('calendario_operacional')
        .select('id, data, regime, ativo, tipo_configuracao, observacao')
        .gte('data', inicio)
        .lte('data', fim)
        .order('data', { ascending: true }),
      supabase
        .from('feriados_oficiais')
        .select('id, data, nome, abrangencia')
        .gte('data', inicio)
        .lte('data', fim)
        .order('data', { ascending: true })
    ])

    loading.value = false

    if (configRes.error || feriadosRes.error) {
      error.value = 'Não foi possível carregar o calendário operacional.'
      configuracoes.value = []
      feriados.value = []
      return
    }

    configuracoes.value = (configRes.data as CalendarioConfiguracao[] | null) ?? []
    feriados.value = (feriadosRes.data as FeriadoOficial[] | null) ?? []
  }

  const criarConfiguracao = async (data: CalendarioOperacionalFormData): Promise<CalendarioResult> => {
    saving.value = true

    const { error: insertError } = await supabase.from('calendario_operacional').insert({
      data: data.data,
      regime: data.regime,
      ativo: data.ativo,
      tipo_configuracao: data.tipo_configuracao,
      observacao: data.observacao.trim() || null
    })

    saving.value = false

    if (insertError) {
      return { success: false, error: mapCalendarioError(insertError) }
    }

    return { success: true, error: null }
  }

  const atualizarConfiguracao = async (
    id: string,
    data: CalendarioOperacionalFormData
  ): Promise<CalendarioResult> => {
    saving.value = true

    const { error: updateError } = await supabase
      .from('calendario_operacional')
      .update({
        data: data.data,
        regime: data.regime,
        ativo: data.ativo,
        tipo_configuracao: data.tipo_configuracao,
        observacao: data.observacao.trim() || null
      })
      .eq('id', id)

    saving.value = false

    if (updateError) {
      return { success: false, error: mapCalendarioError(updateError) }
    }

    return { success: true, error: null }
  }

  const restaurarPadrao = async (id: string): Promise<CalendarioResult> => {
    saving.value = true

    const { error: deleteError } = await supabase
      .from('calendario_operacional')
      .delete()
      .eq('id', id)

    saving.value = false

    if (deleteError) {
      return { success: false, error: mapCalendarioError(deleteError) }
    }

    return { success: true, error: null }
  }

  return {
    configuracoes,
    feriados,
    loading,
    error,
    saving,
    carregarMes,
    criarConfiguracao,
    atualizarConfiguracao,
    restaurarPadrao
  }
}
