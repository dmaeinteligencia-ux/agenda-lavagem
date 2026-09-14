interface LoginCredentials {
  email: string
  password: string
}

interface SignupCredentials {
  nome: string
  email: string
  password: string
}

interface AuthError {
  message: string
  status?: number
}

export interface PerfilUsuario {
  id: string
  nome: string | null
  perfil: string
  status_acesso: string
}

export type StatusLogin = 'ATIVO' | 'PENDENTE' | 'BLOQUEADO' | 'SEM_PERFIL'

interface SignInResult {
  success: boolean
  status: StatusLogin | null
  message: string | null
}

interface SignUpResult {
  success: boolean
  needsEmailConfirmation: boolean
  message: string | null
}

const mapAuthError = (err: { message?: string } | null): string => {
  const msg = (err?.message ?? '').toLowerCase()

  if (msg.includes('invalid login credentials')) {
    return 'E-mail ou senha incorretos.'
  }
  if (msg.includes('already registered')) {
    return 'Este e-mail já está cadastrado.'
  }
  if (msg.includes('password should be')) {
    return 'A senha não atende aos requisitos mínimos.'
  }
  if (msg.includes('unable to validate email') || msg.includes('invalid email')) {
    return 'E-mail inválido.'
  }
  if (msg.includes('email not confirmed')) {
    return 'Confirme seu e-mail antes de entrar.'
  }
  if (msg.includes('too many requests')) {
    return 'Muitas tentativas. Aguarde um instante e tente novamente.'
  }

  return 'Não foi possível concluir a operação. Tente novamente.'
}

export const useAuth = () => {
  const supabase = useSupabaseClient()
  const user = useSupabaseUser()

  const isLoading = ref(false)
  const error = ref<string | null>(null)

  const fetchMyProfile = async (
    userId?: string
  ): Promise<{
    profile: PerfilUsuario | null
    error: AuthError | null
  }> => {
    const currentUserId = userId ?? user.value?.sub

    if (!currentUserId) {
      return {
        profile: null,
        error: { message: 'Usuário não autenticado.' }
      }
    }

    const { data, error: profileError } = await supabase
      .from('perfis_usuarios')
      .select('id, nome, perfil, status_acesso')
      .eq('id', currentUserId)
      .maybeSingle()

    return {
      profile: (data as PerfilUsuario | null) ?? null,
      error: profileError
    }
  }

  const signIn = async ({ email, password }: LoginCredentials): Promise<SignInResult> => {
    isLoading.value = true
    error.value = null

    try {
      const { data, error: signInError } = await supabase.auth.signInWithPassword({
        email,
        password
      })

      if (signInError) {
        const message = mapAuthError(signInError)
        error.value = message
        return { success: false, status: null, message }
      }

      const { profile, error: profileError } = await fetchMyProfile(data?.user?.id)

      if (profileError) {
        error.value = 'Não foi possível verificar seu perfil.'
        await supabase.auth.signOut()
        return {
          success: false,
          status: null,
          message: 'Não foi possível verificar seu perfil.'
        }
      }

      if (!profile) {
        error.value = 'Seu usuário não possui um perfil configurado. Entre em contato com o administrador.'
        await supabase.auth.signOut()
        return {
          success: false,
          status: 'SEM_PERFIL',
          message: error.value
        }
      }

      if (profile.status_acesso === 'PENDENTE') {
        await supabase.auth.signOut()
        return { success: false, status: 'PENDENTE', message: null }
      }

      if (profile.status_acesso === 'BLOQUEADO') {
        await supabase.auth.signOut()
        return { success: false, status: 'BLOQUEADO', message: null }
      }

      await navigateTo('/')
      return { success: true, status: 'ATIVO', message: null }
    } catch (err) {
      const e = err as AuthError
      const message = e.message || 'Erro ao entrar no sistema.'
      error.value = message
      return { success: false, status: null, message }
    } finally {
      isLoading.value = false
    }
  }

  const signUp = async ({ nome, email, password }: SignupCredentials): Promise<SignUpResult> => {
    isLoading.value = true
    error.value = null

    try {
      const { data, error: signUpError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            full_name: nome.trim()
          }
        }
      })

      if (signUpError) {
        const message = mapAuthError(signUpError)
        error.value = message
        return { success: false, needsEmailConfirmation: false, message }
      }

      const needsEmailConfirmation = !!data.user && !data.session

      return { success: true, needsEmailConfirmation, message: null }
    } catch (err) {
      const e = err as AuthError
      const message = e.message || 'Erro ao realizar o cadastro.'
      error.value = message
      return { success: false, needsEmailConfirmation: false, message }
    } finally {
      isLoading.value = false
    }
  }

  const signOut = async () => {
    isLoading.value = true
    error.value = null

    try {
      const { error: signOutError } = await supabase.auth.signOut()
      if (signOutError) {
        const message = mapAuthError(signOutError)
        error.value = message
        return { success: false, message }
      }
      return { success: true, message: null }
    } catch (err) {
      const e = err as AuthError
      const message = e.message || 'Erro ao sair do sistema.'
      error.value = message
      return { success: false, message }
    } finally {
      isLoading.value = false
    }
  }

  return {
    user,
    isLoading: readonly(isLoading),
    error: readonly(error),
    signIn,
    signUp,
    signOut,
    fetchMyProfile
  }
}
