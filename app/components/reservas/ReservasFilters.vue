<template>
  <div class="reservas-filters">
    <div class="filter-group">
      <label class="filter-label" for="reservas-filtro-data-inicial">Data inicial</label>
      <div class="filter-select-wrapper">
        <input
          id="reservas-filtro-data-inicial"
          class="filter-select filter-select--date"
          type="date"
          :value="dataInicial"
          @change="$emit('update:dataInicial', ($event.target as HTMLInputElement).value)"
        />
      </div>
    </div>
    <div class="filter-group">
      <label class="filter-label" for="reservas-filtro-data-final">Data final</label>
      <div class="filter-select-wrapper">
        <input
          id="reservas-filtro-data-final"
          class="filter-select filter-select--date"
          type="date"
          :value="dataFinal"
          @change="$emit('update:dataFinal', ($event.target as HTMLInputElement).value)"
        />
      </div>
    </div>
    <div class="filter-group">
      <label class="filter-label" for="reservas-filtro-status">Status</label>
      <div class="filter-select-wrapper">
        <select
          id="reservas-filtro-status"
          class="filter-select"
          :value="status"
          @change="$emit('update:status', ($event.target as HTMLSelectElement).value)"
        >
          <option value="">Todos os status</option>
          <option v-for="item in statusOpcoes" :key="item.value" :value="item.value">
            {{ item.label }}
          </option>
        </select>
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
    <div class="filter-group">
      <label class="filter-label" for="reservas-filtro-tipo">Tipo de veículo</label>
      <div class="filter-select-wrapper">
        <select
          id="reservas-filtro-tipo"
          class="filter-select"
          :value="tipoId"
          @change="$emit('update:tipoId', ($event.target as HTMLSelectElement).value)"
        >
          <option value="">Todos os tipos</option>
          <option v-for="item in tipos" :key="item.id" :value="item.id">
            {{ item.descricao }}
          </option>
        </select>
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
    <button
      type="button"
      class="filter-clear-btn"
      :disabled="!podeLimpar"
      @click="$emit('limpar')"
    >
      <ArrowPathIcon class="filter-clear-icon" aria-hidden="true" />
      Limpar filtros
    </button>
  </div>
</template>

<script setup lang="ts">
import { ChevronDownIcon, ArrowPathIcon } from '@heroicons/vue/24/outline'
import { STATUS_OPCOES, type TipoVeiculoAdmin } from '@/utils/reservasAdmin'

interface Props {
  dataInicial: string
  dataFinal: string
  status: string
  tipoId: string
  tipos: TipoVeiculoAdmin[]
  podeLimpar: boolean
}

defineProps<Props>()

defineEmits<{
  'update:dataInicial': [value: string]
  'update:dataFinal': [value: string]
  'update:status': [value: string]
  'update:tipoId': [value: string]
  limpar: []
}>()

const statusOpcoes = STATUS_OPCOES
</script>

<style scoped>
.reservas-filters {
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
  min-width: 160px;
  appearance: none;
  padding-right: 36px;
  box-sizing: border-box;
}

.filter-select--date {
  padding-right: 12px;
  appearance: auto;
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

.filter-clear-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  align-self: flex-end;
  padding: 9px 14px;
  font-size: 14px;
  font-weight: 600;
  color: #4b5563;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.15s, border-color 0.15s, color 0.15s;
}

.filter-clear-btn:hover:not(:disabled) {
  background: #f9fafb;
  border-color: #d1d5db;
  color: #004790;
}

.filter-clear-btn:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.filter-clear-icon {
  width: 16px;
  height: 16px;
}

@media (max-width: 768px) {
  .reservas-filters {
    flex-direction: column;
  }

  .filter-select {
    width: 100%;
  }

  .filter-clear-btn {
    align-self: stretch;
    justify-content: center;
  }
}
</style>
