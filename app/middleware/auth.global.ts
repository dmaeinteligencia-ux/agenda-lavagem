import {
  ehPerfilValido,
  ehRotaLogin,
  ehRotaPublica,
  podeAcessarRota,
  rotaInicialPorPerfil
} from '@/utils/accessControl'

export default defineNuxtRouteMiddleware(async (to) => {
  const user = useSupabaseUser()
  const isPublic = ehRotaPublica(to.path)

  // 1. Não autenticado: apenas rotas públicas são permitidas.
  if (!user.value) {
    if (isPublic) {
      return
    }
    return navigateTo('/login')
  }

  // 2. Autenticado: resolver status de acesso + perfil.
  //    Cache por usuário (acesso-status / acesso-perfil / acesso-user-id);
  //    se o usuário mudar, o cache é invalidado e o perfil é reconsultado.
  const { resolverAcesso, acessoPerfil } = useAuth()
  const status = await resolverAcesso()

  // 3. Rotas públicas com usuário autenticado.
  if (isPublic) {
    if (!ehRotaLogin(to.path)) {
      return
    }

    const perfil = acessoPerfil.value
    if (status === 'ATIVO' && ehPerfilValido(perfil)) {
      return navigateTo(rotaInicialPorPerfil(perfil))
    }

    return
  }

  // 4. Rotas internas: somente ATIVO atravessa.
  if (status !== 'ATIVO') {
    return navigateTo({ path: '/login', query: { motivo: status } })
  }

  // 5. Autorização por perfil (matriz central).
  const perfil = acessoPerfil.value

  if (!ehPerfilValido(perfil)) {
    return navigateTo({ path: '/login', query: { motivo: 'SEM_PERFIL' } })
  }

  if (!podeAcessarRota(perfil, to.path)) {
    return navigateTo(rotaInicialPorPerfil(perfil))
  }
})
