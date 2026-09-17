export interface TipoVeiculo {
  id: string
  descricao: string
  tempo_min: number
  created_at: string
  updated_at: string
}

export interface TipoVeiculoFormData {
  descricao: string
  tempo_min: number
}

export function tipoCorrespondeBusca(tipo: TipoVeiculo, busca: string): boolean {
  const termo = busca.trim().toLowerCase()

  if (!termo) {
    return true
  }

  return (
    tipo.descricao.toLowerCase().includes(termo) ||
    String(tipo.tempo_min).includes(termo)
  )
}
