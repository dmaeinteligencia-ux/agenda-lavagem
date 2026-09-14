<template>
  <header class="calendario-operacional-page-header">
    <div class="calendario-operacional-page-header-text">
      <h1 class="calendario-operacional-page-header-title">Calendário Operacional</h1>
      <p class="calendario-operacional-page-header-subtitle">Gerencie feriados, exceções e regimes específicos por data.</p>
    </div>
    <button
      type="button"
      class="calendario-operacional-new-config-btn"
      aria-label="Nova Configuração"
      @click="$emit('new-configuracao')"
    >
      <PlusIcon class="calendario-operacional-new-config-btn-icon" aria-hidden="true" />
      Nova Configuração
    </button>
  </header>
</template>

<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'

defineEmits<{
  'new-configuracao': []
}>()
</script>

<style scoped>
.calendario-operacional-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.calendario-operacional-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.calendario-operacional-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.calendario-operacional-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.calendario-operacional-new-config-btn {
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

.calendario-operacional-new-config-btn:hover {
  background-color: #003570;
}

.calendario-operacional-new-config-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.calendario-operacional-new-config-btn-icon {
  width: 18px;
  height: 18px;
}

@media (max-width: 600px) {
  .calendario-operacional-page-header {
    align-items: flex-start;
  }

  .calendario-operacional-page-header-title {
    font-size: 20px;
  }

  .calendario-operacional-page-header-subtitle {
    font-size: 13px;
  }
}
</style>
