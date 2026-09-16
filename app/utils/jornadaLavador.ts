export type RegimeJornada = 'NORMAL' | 'PLANTAO'

export interface JornadaLavador {
  id: string
  regime: RegimeJornada
  horas_disponiveis: number
  created_at: string
  updated_at: string
}

export interface JornadaLavadorFormData {
  regime: RegimeJornada
  horas_disponiveis: number
}

export interface ResumoJornada {
  regimesConfigurados: number
  horasNormal: number | null
  horasPlantao: number | null
}

export const DIAS_POR_REGIME: Record<RegimeJornada, string> = {
  NORMAL: 'Segunda a sexta-feira',
  PLANTAO: 'Sábados, domingos e feriados'
}

export function isRegimeJornada(valor: unknown): valor is RegimeJornada {
  return valor === 'NORMAL' || valor === 'PLANTAO'
}

export function diasPorRegime(regime: RegimeJornada): string {
  return DIAS_POR_REGIME[regime] ?? '—'
}

export function resumoJornada(jornadas: JornadaLavador[]): ResumoJornada {
  const normal = jornadas.find((jornada) => jornada.regime === 'NORMAL')
  const plantao = jornadas.find((jornada) => jornada.regime === 'PLANTAO')

  return {
    regimesConfigurados: jornadas.length,
    horasNormal: normal ? normal.horas_disponiveis : null,
    horasPlantao: plantao ? plantao.horas_disponiveis : null
  }
}
