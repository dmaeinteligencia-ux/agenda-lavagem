export interface NovaReservaVehicle {
  identification: string
  plate: string
  type: string
}

export interface NovaReservaCapacity {
  total: string
  used: string
  available: string
}

export interface NovaReservaDemo {
  vehicle: NovaReservaVehicle
  date: string
  regime: string
  capacity: NovaReservaCapacity
  utilization: string
  utilizationPercent: number
  estimatedTime: string
  availability: 'Disponível' | 'Indisponível'
}

export const demoReservation: NovaReservaDemo = {
  vehicle: {
    identification: 'A11-1234',
    plate: 'ABC-1A23',
    type: 'Caminhão'
  },
  date: '27/05/2026',
  regime: 'PLANTÃO',
  capacity: {
    total: '480 min',
    used: '312 min',
    available: '168 min'
  },
  utilization: '65% utilizado',
  utilizationPercent: 65,
  estimatedTime: '90 minutos',
  availability: 'Disponível'
}