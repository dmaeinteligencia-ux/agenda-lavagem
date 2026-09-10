export type RegimeJornada = 'NORMAL' | 'PLANTAO'

export interface JornadaLavadorMock {
  id: string
  regime: RegimeJornada
  dias: string
  horas: number
  disponivel_agendamento: boolean
}

export interface JornadaLavadorFormData {
  regime: RegimeJornada
  horas: number
  disponivel_agendamento: boolean
}

export const diasPorRegime = (regime: RegimeJornada): string =>
  regime === 'NORMAL'
    ? 'Segunda a sexta-feira'
    : 'Sábados, domingos e feriados'

export const jornadasLavadorMock: JornadaLavadorMock[] = [
  {
    id: '1',
    regime: 'NORMAL',
    dias: 'Segunda a sexta-feira',
    horas: 8,
    disponivel_agendamento: true
  },
  {
    id: '2',
    regime: 'PLANTAO',
    dias: 'Sábados, domingos e feriados',
    horas: 8,
    disponivel_agendamento: true
  }
]

export const jornadaLavadorSummary = {
  regimesConfigurados: '2',
  jornadaNormal: '8h',
  plantaoDisponivel: true
}
