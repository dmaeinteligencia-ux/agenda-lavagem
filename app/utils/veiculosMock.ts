export type VeiculoSituacao = 'ATIVO' | 'INATIVO'

export interface VeiculoMock {
  id: number
  identification: string
  plate: string
  type: string
  equipment: string
  situacao: VeiculoSituacao
}

export const veiculosMock: VeiculoMock[] = [
  { id: 1, identification: 'A11', plate: 'ABC-1A23', type: 'Caminhão', equipment: '000001', situacao: 'ATIVO' },
  { id: 2, identification: 'A12', plate: 'DEF-2B34', type: 'Carro', equipment: '000002', situacao: 'ATIVO' },
  { id: 3, identification: 'A15', plate: 'GHI-3C45', type: 'Máquina', equipment: '000003', situacao: 'ATIVO' },
  { id: 4, identification: 'A21', plate: 'JKL-4D56', type: 'Ônibus', equipment: '000004', situacao: 'ATIVO' },
  { id: 5, identification: 'A08', plate: 'MNO-5E67', type: 'Moto', equipment: '000005', situacao: 'INATIVO' },
  { id: 6, identification: 'A03', plate: 'PQR-6F78', type: 'Carro', equipment: '000006', situacao: 'ATIVO' },
  { id: 7, identification: 'A17', plate: 'STU-7G89', type: 'Caminhão', equipment: '000007', situacao: 'ATIVO' },
  { id: 8, identification: 'A25', plate: 'VWX-8H90', type: 'Ônibus', equipment: '000008', situacao: 'ATIVO' },
  { id: 9, identification: 'A05', plate: 'YZA-9I01', type: 'Moto', equipment: '000009', situacao: 'INATIVO' },
  { id: 10, identification: 'A19', plate: 'BCD-0J12', type: 'Máquina', equipment: '000010', situacao: 'ATIVO' },
  { id: 11, identification: 'A23', plate: 'EFG-1K23', type: 'Carro', equipment: '000011', situacao: 'ATIVO' },
  { id: 12, identification: 'A31', plate: 'HIJ-2L45', type: 'Caminhão', equipment: '000012', situacao: 'INATIVO' }
]

export const veiculosSummary = {
  total: '128',
  ativos: '121',
  inativos: '7',
  tipos: '5'
}