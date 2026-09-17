import type { Solicitante, SolicitanteFormData } from '@/utils/solicitantes'

interface SolicitanteErro {
  code?: string
  message?: string
}

interface SolicitanteResult {
  data: Solicitante | null
  error: SolicitanteErro | null
}

export const useSolicitantes = () => {
  const supabase = useSupabaseClient()

  const solicitantes = ref<Solicitante[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const fetchSolicitantes = async () => {
    loading.value = true
    error.value = null

    const { data, error: fetchError } = await supabase
      .from('solicitantes_lavagem')
      .select('id, matricula, nome, telefone')
      .order('nome', { ascending: true })

    loading.value = false

    if (fetchError) {
      error.value = 'Não foi possível carregar os solicitantes.'
      console.error('Erro ao carregar solicitantes:', fetchError)
      return
    }

    solicitantes.value = (data as Solicitante[]) ?? []
  }

  const createSolicitante = async (input: SolicitanteFormData): Promise<SolicitanteResult> => {
    const { data, error: createError } = await supabase
      .from('solicitantes_lavagem')
      .insert({
        matricula: input.matricula,
        nome: input.nome,
        telefone: input.telefone
      })
      .select('id, matricula, nome, telefone')
      .single()

    return {
      data: (data as Solicitante | null) ?? null,
      error: createError
    }
  }

  const updateSolicitante = async (id: string, input: SolicitanteFormData): Promise<SolicitanteResult> => {
    const { data, error: updateError } = await supabase
      .from('solicitantes_lavagem')
      .update({
        matricula: input.matricula,
        nome: input.nome,
        telefone: input.telefone
      })
      .eq('id', id)
      .select('id, matricula, nome, telefone')
      .single()

    return {
      data: (data as Solicitante | null) ?? null,
      error: updateError
    }
  }

  return {
    solicitantes,
    loading,
    error,
    fetchSolicitantes,
    createSolicitante,
    updateSolicitante
  }
}
