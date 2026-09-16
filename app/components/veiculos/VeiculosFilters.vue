<template>
  <div class="veiculos-filters">
    <div class="filter-group">
      <label class="filter-label" for="veiculos-filtro-tipo">Tipo de Veículo</label>
      <div class="filter-select-wrapper">
        <select
          id="veiculos-filtro-tipo"
          class="filter-select"
          :value="tipo"
          @change="$emit('update:tipo', ($event.target as HTMLSelectElement).value)"
        >
          <option value="">Todos os tipos</option>
          <option v-for="item in tipos" :key="item.id" :value="item.id">
            {{ item.descricao }}
          </option>
        </select>
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
    <div class="filter-group">
      <label class="filter-label" for="veiculos-filtro-situacao">Situação</label>
      <div class="filter-select-wrapper">
        <select
          id="veiculos-filtro-situacao"
          class="filter-select"
          :value="situacao"
          @change="$emit('update:situacao', ($event.target as HTMLSelectElement).value as VeiculoSituacaoFiltro)"
        >
          <option v-for="item in situacoes" :key="item.value" :value="item.value">
            {{ item.label }}
          </option>
        </select>
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
import { SITUACOES_VEICULO, type TipoVeiculo, type VeiculoSituacaoFiltro } from '@/utils/veiculos'

interface Props {
  tipo: string
  situacao: VeiculoSituacaoFiltro
  tipos: TipoVeiculo[]
}

defineProps<Props>()

defineEmits<{
  'update:tipo': [value: string]
  'update:situacao': [value: VeiculoSituacaoFiltro]
}>()

const situacoes = SITUACOES_VEICULO
</script>

<style scoped>
.veiculos-filters {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 24px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.filter-label {
  font-size: 12px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.filter-select-wrapper {
  position: relative;
}

.filter-select {
  padding: 8px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  font-family: inherit;
  cursor: pointer;
  min-width: 180px;
  appearance: none;
  padding-right: 36px;
}

.filter-select:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}

.filter-icon {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  width: 16px;
  height: 16px;
  color: #6b7280;
  pointer-events: none;
}

@media (max-width: 768px) {
  .veiculos-filters {
    flex-direction: column;
  }

  .filter-select {
    width: 100%;
  }
}
</style>
