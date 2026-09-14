<template>
  <header class="solicitantes-page-header">
    <div class="solicitantes-page-header-text">
      <h1 class="solicitantes-page-header-title">Solicitantes</h1>
      <p class="solicitantes-page-header-subtitle">Gerencie os solicitantes autorizados a reservar lavagens da frota.</p>
    </div>
    <button
      type="button"
      class="solicitantes-new-solicitante-btn"
      aria-label="Novo Solicitante"
      @click="$emit('new-solicitante')"
    >
      <PlusIcon class="solicitantes-new-solicitante-btn-icon" aria-hidden="true" />
      Novo Solicitante
    </button>
  </header>
</template>

<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'

defineEmits<{
  'new-solicitante': []
}>()
</script>

<style scoped>
.solicitantes-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.solicitantes-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.solicitantes-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.solicitantes-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.solicitantes-new-solicitante-btn {
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

.solicitantes-new-solicitante-btn:hover {
  background-color: #003570;
}

.solicitantes-new-solicitante-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.solicitantes-new-solicitante-btn-icon {
  width: 18px;
  height: 18px;
}

@media (max-width: 600px) {
  .solicitantes-page-header {
    align-items: flex-start;
  }

  .solicitantes-page-header-title {
    font-size: 20px;
  }

  .solicitantes-page-header-subtitle {
    font-size: 13px;
  }
}
</style>
