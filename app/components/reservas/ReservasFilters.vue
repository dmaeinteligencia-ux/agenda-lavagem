<template>
  <div class="reservas-filters">
    <div class="filter-group">
      <label class="filter-label">Data</label>
      <div class="filter-select-wrapper">
        <input type="text" class="filter-select" placeholder="Todas as datas" readonly />
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
    <div class="filter-group">
      <label class="filter-label">Status</label>
      <div class="filter-select-wrapper">
        <input type="text" class="filter-select" placeholder="Todos os status" readonly />
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
    <div class="filter-group">
      <label class="filter-label">Regime</label>
      <div class="filter-select-wrapper">
        <input type="text" class="filter-select" placeholder="Todos" readonly />
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
    <div class="filter-group">
      <label class="filter-label">Tipo de veículo</label>
      <div class="filter-select-wrapper">
        <input type="text" class="filter-select" placeholder="Todos os tipos" readonly />
        <ChevronDownIcon class="filter-icon" aria-hidden="true" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
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
  .reservas-filters {
    flex-direction: column;
  }

  .filter-select {
    width: 100%;
  }
}
</style>