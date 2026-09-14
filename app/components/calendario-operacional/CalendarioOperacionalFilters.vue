<template>
  <div class="calendario-operacional-filters">
    <div class="filter-group">
      <label class="filter-label">Regime</label>
      <div class="filter-select-wrapper">
        <select
          class="filter-select"
          :value="modelValue"
          @change="$emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
        >
          <option value="">Todos</option>
          <option value="NORMAL">NORMAL</option>
          <option value="PLANTAO">PLANTÃO</option>
        </select>
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronDownIcon } from '@heroicons/vue/24/outline'

interface Props {
  modelValue: string
}

defineProps<Props>()

defineEmits<{
  'update:modelValue': [value: string]
}>()
</script>

<style scoped>
.calendario-operacional-filters {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
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
  padding: 8px 36px 8px 12px;
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
  .calendario-operacional-filters {
    flex-direction: column;
  }

  .filter-select {
    width: 100%;
  }
}
</style>
