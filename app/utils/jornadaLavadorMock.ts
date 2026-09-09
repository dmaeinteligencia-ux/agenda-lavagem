import { ref } from 'vue'
import { Dialog } from 'primevue/dialog'
import { Button } from 'primevue/button'
import { InputNumber } from 'primevue/inputnumber'
import { Dropdown } from 'primevue/dropdown'
import { Toast } from 'primevue/toast'

export type JornadaLavador = {
  id: string
  regime: 'NORMAL' | 'PLANTAO'
  horas_disponiveis: number
  created_at?: string
  updated_at?: string
}

export type JornadaLavadorSummary = {
  totalRegimes: number
  normalHours: number
  plantaoHours: number
  averageCapacity: number
}

export const jornadasLavadorMock: JornadaLavador[] = [
  { id: '1', regime: 'NORMAL', horas_disponiveis: 8, created_at: '2025-01-15T10:00:00Z' },
  { id: '2', regime: 'PLANTAO', horas_disponiveis: 6, created_at: '2025-01-16T14:30:00Z' }
]

export const jornadaLavadorSummary = () => {
  const totalRegimes = jornadasLavadorMock.length
  const normalHours = jornadasLavadorMock
    .filter(j => j.regime === 'NORMAL')
    .reduce((sum, j) => sum + j.horas_disponiveis, 0)
  const plantaoHours = jornadasLavadorMock
    .filter(j => j.regime === 'PLANTAO')
    .reduce((sum, j) => sum + j.horas_disponiveis, 0)
  const averageCapacity = (normalHours + plantaoHours) / totalRegimes

  return {
    totalRegimes: totalRegimes.toString(),
    normalHours: normalHours.toString(),
    plantaoHours: plantaoHours.toString(),
    averageCapacity: averageCapacity.toFixed(1)
  }
}