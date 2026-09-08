export type ReservaStatus = 'RESERVADA' | 'EM_LAVAGEM' | 'CONCLUIDA' | 'CANCELADA' | 'EXPIRADA'

export interface ReservaMock {
  id: number
  vehicle: string
  plate: string
  type: string
  date: string
  weekday?: string
  regime: string
  time: string
  status: ReservaStatus
}

export const reservasMock: ReservaMock[] = [
  { id: 1, vehicle: 'A11', plate: 'ABC-1A23', type: 'Caminhão', date: '02/09/2026', weekday: 'Quarta-feira', regime: 'NORMAL', time: '90 min', status: 'RESERVADA' },
  { id: 2, vehicle: 'A12', plate: 'DEF-2B34', type: 'Carro', date: '02/09/2026', weekday: 'Quarta-feira', regime: 'NORMAL', time: '45 min', status: 'EM_LAVAGEM' },
  { id: 3, vehicle: 'A15', plate: 'GHI-3C45', type: 'Máquina', date: '02/09/2026', weekday: 'Quarta-feira', regime: 'NORMAL', time: '120 min', status: 'CONCLUIDA' },
  { id: 4, vehicle: 'A21', plate: 'JKL-4D56', type: 'Ônibus', date: '03/09/2026', weekday: 'Quinta-feira', regime: 'NORMAL', time: '120 min', status: 'RESERVADA' },
  { id: 5, vehicle: 'A08', plate: 'MNO-5E67', type: 'Moto', date: '03/09/2026', weekday: 'Quinta-feira', regime: 'NORMAL', time: '30 min', status: 'CANCELADA' },
  { id: 6, vehicle: 'A03', plate: 'PQR-6F78', type: 'Carro', date: '04/09/2026', weekday: 'Sexta-feira', regime: 'PLANTAO', time: '45 min', status: 'RESERVADA' },
  { id: 7, vehicle: 'A17', plate: 'STU-7G89', type: 'Caminhão', date: '04/09/2026', weekday: 'Sexta-feira', regime: 'PLANTAO', time: '90 min', status: 'CONCLUIDA' },
  { id: 8, vehicle: 'A25', plate: 'VWX-8H90', type: 'Ônibus', date: '05/09/2026', weekday: 'Sábado', regime: 'NORMAL', time: '120 min', status: 'EM_LAVAGEM' },
  { id: 9, vehicle: 'A05', plate: 'YZA-9I01', type: 'Moto', date: '05/09/2026', weekday: 'Sábado', regime: 'NORMAL', time: '30 min', status: 'EXPIRADA' },
  { id: 10, vehicle: 'A19', plate: 'BCD-0J12', type: 'Máquina', date: '06/09/2026', weekday: 'Domingo', regime: 'PLANTAO', time: '120 min', status: 'RESERVADA' }
]

export const reservasSummary = {
  total: '24',
  reserved: '12',
  washing: '3',
  completed: '9'
}