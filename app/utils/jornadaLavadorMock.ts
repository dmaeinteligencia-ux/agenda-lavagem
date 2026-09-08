export type JornadaLavadorMock = {
  id: string
  regime: 'NORMAL' | 'PLANTAO'
  horas_disponiveis: number
}

export const jornadasLavadorMock: JornadaLavadorMock[] = [
  { id: '1', regime: 'NORMAL', horas_disponiveis: 8 },
  { id: '2', regime: 'PLANTAO', horas_disponiveis: 4 }
]

export const jornadaLavadorSummary = {
  total_regimes: '2',
  regulas_configuradas: '2'
}