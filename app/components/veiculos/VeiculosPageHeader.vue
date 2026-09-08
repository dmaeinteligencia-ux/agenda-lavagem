<template>
  <header class="veiculos-page-header">
    <div class="veiculos-page-header-text">
      <h1 class="veiculos-page-header-title">Veículos</h1>
      <p class="veiculos-page-header-subtitle">Consulte os veículos da frota disponíveis para as operações de lavagem.</p>
    </div>
    <button
      type="button"
      class="veiculos-new-veiculo-btn"
      aria-label="Novo Veículo"
      @click="$emit('new-veiculo')"
    >
      <PlusIcon class="veiculos-new-veiculo-btn-icon" aria-hidden="true" />
      Novo Veículo
    </button>
  </header>
</template>

<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.veiculos-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.veiculos-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.veiculos-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.veiculos-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.veiculos-new-veiculo-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.veiculos-new-veiculo-btn:hover {
  background-color: #003570;
}

.veiculos-new-veiculo-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.veiculos-new-veiculo-btn-icon {
  width: 18px;
  height: 18px;
}

@media (max-width: 600px) {
  .veiculos-page-header {
    align-items: flex-start;
  }

  .veiculos-page-header-title {
    font-size: 20px;
  }

  .veiculos-page-header-subtitle {
    font-size: 13px;
  }
}
</style>