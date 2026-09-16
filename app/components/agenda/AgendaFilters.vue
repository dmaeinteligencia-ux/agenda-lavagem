<template>
  <div class="agenda-filters">
    <div class="filter-group">
      <label class="filter-label">Tipo</label>
      <select class="filter-select" :value="tipo" @change="$emit('update:tipo', ($event.target as HTMLSelectElement).value)">
        <option value="">Todos</option>
        <option v-for="t in tipos" :key="t" :value="t">{{ t }}</option>
      </select>
    </div>
    <div class="filter-group">
      <label class="filter-label">Status</label>
      <select class="filter-select" :value="status" @change="$emit('update:status', ($event.target as HTMLSelectElement).value)">
        <option value="">Todos</option>
        <option v-for="s in statuses" :key="s.value" :value="s.value">{{ s.label }}</option>
      </select>
    </div>
    <div class="filter-group">
      <label class="filter-label">Regime</label>
      <select class="filter-select" :value="regime" @change="$emit('update:regime', ($event.target as HTMLSelectElement).value)">
        <option value="">Todos</option>
        <option value="NORMAL">Normal</option>
        <option value="PLANTAO">Plantão</option>
      </select>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  tipos: string[]
  tipo: string
  status: string
  regime: string
}

defineProps<Props>()

defineEmits<{
  'update:tipo': [value: string]
  'update:status': [value: string]
  'update:regime': [value: string]
}>()

const statuses = [
  { value: 'RESERVADA', label: 'Reservada' },
  { value: 'EM_LAVAGEM', label: 'Em lavagem' },
  { value: 'CONCLUIDA', label: 'Concluída' },
  { value: 'CANCELADA', label: 'Cancelada' },
  { value: 'EXPIRADA', label: 'Expirada' },
  { value: 'NAO_COMPARECEU', label: 'Não compareceu' },
  { value: 'NAO_ATENDIDA', label: 'Não atendida' },
  { value: 'NAO_CONCLUIDA', label: 'Não concluída' }
]
</script>

<style scoped>
.agenda-filters {
  display: flex;
  gap: 16px;
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
}

.filter-select:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}
</style>
