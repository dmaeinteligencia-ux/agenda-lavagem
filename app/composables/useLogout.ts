export const useLogout = () => {
  const { signOut } = useAuth()

  const loggingOut = ref(false)
  const logoutError = ref<string | null>(null)

  const handleLogout = async (): Promise<void> => {
    if (loggingOut.value) {
      return
    }

    loggingOut.value = true
    logoutError.value = null

    const result = await signOut()
    loggingOut.value = false

    if (!result.success) {
      logoutError.value = result.message || 'Não foi possível sair.'
      return
    }

    await navigateTo('/login')
  }

  return {
    loggingOut,
    logoutError,
    handleLogout
  }
}
