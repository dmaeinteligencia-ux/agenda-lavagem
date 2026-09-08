interface LoginCredentials {
  email: string
  password: string
}

interface AuthError {
  message: string
  status?: number
}

export const useAuth = () => {
  const supabase = useSupabaseClient()
  const user = useSupabaseUser()

  const isLoading = ref(false)
  const error = ref<string | null>(null)

  const signIn = async ({ email, password }: LoginCredentials) => {
    isLoading.value = true
    error.value = null

    try {
      const { error: signInError } = await supabase.auth.signInWithPassword({
        email,
        password
      })

      if (signInError) {
        error.value = signInError.message
        return { success: false, error: signInError }
      }

      await navigateTo('/')
      return { success: true, error: null }
    } catch (err) {
      const e = err as AuthError
      error.value = e.message || 'Erro ao entrar no sistema.'
      return { success: false, error: e }
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
        error.value = signOutError.message
        return { success: false, error: signOutError }
      }
      return { success: true, error: null }
    } catch (err) {
      const e = err as AuthError
      error.value = e.message || 'Erro ao sair do sistema.'
      return { success: false, error: e }
    } finally {
      isLoading.value = false
    }
  }

  return {
    user,
    isLoading: readonly(isLoading),
    error: readonly(error),
    signIn,
    signOut
  }
}
