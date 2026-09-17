export type Perfil = 'ADMIN' | 'GESTAO_FROTA' | 'LAVADOR'

export type RotaInterna =
  | '/'
  | '/agenda-lavador'
  | '/reservas'
  | '/relatorios'
  | '/veiculos'
  | '/solicitantes'
  | '/tipos-veiculo'
  | '/jornada-lavador'
  | '/calendario-operacional'
  | '/usuarios'

export const ROTA_LOGIN = '/login'

export const ROTAS_PUBLICAS: readonly string[] = [ROTA_LOGIN, '/nova-reserva']

const PERMISSOES: Record<Perfil, readonly RotaInterna[]> = {
  ADMIN: [
    '/',
    '/agenda-lavador',
    '/reservas',
    '/relatorios',
    '/veiculos',
    '/solicitantes',
    '/tipos-veiculo',
    '/jornada-lavador',
    '/calendario-operacional',
    '/usuarios'
  ],
  GESTAO_FROTA: ['/', '/agenda-lavador', '/reservas', '/relatorios', '/veiculos', '/solicitantes'],
  LAVADOR: ['/agenda-lavador']
}

const ROTAS_INICIAIS: Record<Perfil, RotaInterna> = {
  ADMIN: '/agenda-lavador',
  GESTAO_FROTA: '/agenda-lavador',
  LAVADOR: '/agenda-lavador'
}

export function ehPerfilValido(valor: unknown): valor is Perfil {
  return valor === 'ADMIN' || valor === 'GESTAO_FROTA' || valor === 'LAVADOR'
}

function normalizarPath(path: string): string {
  const semQuery = path.split('?')[0].split('#')[0]
  const comBarra = semQuery.startsWith('/') ? semQuery : `/${semQuery}`

  if (comBarra.length > 1 && comBarra.endsWith('/')) {
    return comBarra.slice(0, -1)
  }

  return comBarra
}

export function ehRotaPublica(path: string): boolean {
  return ROTAS_PUBLICAS.includes(normalizarPath(path))
}

export function ehRotaLogin(path: string): boolean {
  return normalizarPath(path) === ROTA_LOGIN
}

export function podeAcessarRota(
  perfil: Perfil | string | null | undefined,
  path: string
): boolean {
  if (!ehPerfilValido(perfil)) {
    return false
  }

  const alvo = normalizarPath(path)

  return PERMISSOES[perfil].some((rota) => {
    if (alvo === rota) {
      return true
    }

    return rota !== '/' && alvo.startsWith(`${rota}/`)
  })
}

export function rotaInicialPorPerfil(perfil: Perfil | string | null | undefined): string {
  return ehPerfilValido(perfil) ? ROTAS_INICIAIS[perfil] : '/login'
}
