<template>
  <header class="tipos-veiculo-page-header">
    <div class="tipos-veiculo-page-header-text">
      <h1 class="tipos-veiculo-page-header-title">Tipos de Veículo</h1>
      <p class="tipos-veiculo-page-header-subtitle">Configure os tipos de veículos e os respectivos tempos de lavagem.</p>
    </div>
    <button type="button" class="tipos-veiculo-new-tipo-btn" aria-label="Novo Tipo" disabled>
      <PlusIcon class="tipos-veiculo-new-tipo-btn-icon" aria-hidden="true" />
      Novo Tipo
    </button>
  </header>
</template>

<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.tipos-veiculo-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.tipos-veiculo-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.tipos-veiculo-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.tipos-veiculo-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.tipos-veiculo-new-tipo-btn {
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

.tipos-veiculo-new-tipo-btn:hover {
  background-color: #003570;
}

.tipos-veiculo-new-tipo-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.tipos-veiculo-new-tipo-btn-icon {
  width: 18px;
  height: 18px;
}

@media (max-width: 600px) {
  .tipos-veiculo-page-header {
    align-items: flex-start;
  }

  .tipos-veiculo-page-header-title {
    font-size: 20px;
  }

  .tipos-veiculo-page-header-subtitle {
    font-size: 13px;
  }
}
</style>