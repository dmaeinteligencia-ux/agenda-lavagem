export type TipoVeiculoMock = {
  id: string
  descricao: string
  tempo_min: number
}

export const tiposVeiculoMock: TipoVeiculoMock[] = [
  { id: '1', descricao: 'Moto', tempo_min: 30 },
  { id: '2', descricao: 'Carro', tempo_min: 45 },
  { id: '3', descricao: 'Caminhão', tempo_min: 90 },
  { id: '4', descricao: 'Máquina', tempo_min: 120 },
  { id: '5', descricao: 'Ônibus', tempo_min: 120 }
]

export const tiposVeiculoSummary = {
  total: '5',
  tipos: '5'
}