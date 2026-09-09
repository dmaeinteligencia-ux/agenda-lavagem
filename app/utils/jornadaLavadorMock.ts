export interface JornadaLavador {
  id: string
  regime: 'NORMAL' | 'PLANTAO'
  horas_disponiveis: number
  created_at: string
  updated_at: string
}

export interface JornadaLavadorSummary {
  totalRegimes: number
  normalHours: number
  plantaoHours: number
  averageCapacity: number
}

export const jornadasLavadorMock: JornadaLavador[] = [
  {
    id: '1',
    regime: 'NORMAL',
    horas_disponiveis: 8,
    created_at: '2025-01-15T10:00:00.000Z',
    updated_at: '2025-01-15T10:00:00.000Z'
  },
  {
    id: '2',
    regime: 'PLANTAO',
    horas_disponiveis: 6,
    created_at: '2025-01-16T14:30:00.000Z',
    updated_at: '2025-01-16T14:30:00.000Z'
  }
]

export const jornadaLavadorSummary: JornadaLavadorSummary = {
  totalRegimes: 2,
  normalHours: 8,
  plantaoHours: 6,
  averageCapacity: 7
}

export function getJornadaSummary(): JornadaLavadorSummary {
  return {
    totalRegimes: 2,
    normalHours: 8,
    plantaoHours: 6,
    averageCapacity: 7
  }
}