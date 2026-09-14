export interface Usuario {
  id: string
  nome: string | null
  email: string
  perfil: 'ADMIN' | 'GESTAO_FROTA' | 'LAVADOR'
  status_acesso: 'PENDENTE' | 'ATIVO' | 'BLOQUEADO'
  created_at: string
}

const mapRpcError = (error: { message?: string } | null): string => {
  return error?.message ?? 'Não foi possível concluir a operação. Tente novamente.'
}

export const useUsuarios = () => {
  const supabase = useSupabaseClient()

  const listarUsuarios = async (): Promise<{ data: Usuario[] | null; error: string | null }> => {
    const { data, error } = await supabase.rpc('listar_usuarios')

    if (error) {
      return { data: null, error: mapRpcError(error) }
    }

    return { data: (data as Usuario[]) ?? [], error: null }
  }

  const alterarStatus = async (
    id: string,
    status: 'PENDENTE' | 'ATIVO' | 'BLOQUEADO'
  ): Promise<{ data: unknown; error: string | null }> => {
    const { data, error } = await supabase.rpc('alterar_status_usuario', {
      p_usuario_id: id,
      p_novo_status: status
    })

    return { data, error: error ? mapRpcError(error) : null }
  }

  const alterarPerfil = async (
    id: string,
    perfil: 'ADMIN' | 'GESTAO_FROTA' | 'LAVADOR'
  ): Promise<{ data: unknown; error: string | null }> => {
    const { data, error } = await supabase.rpc('alterar_perfil_usuario', {
      p_usuario_id: id,
      p_novo_perfil: perfil
    })

    return { data, error: error ? mapRpcError(error) : null }
  }

  return {
    listarUsuarios,
    alterarStatus,
    alterarPerfil
  }
}
