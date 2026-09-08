<template>
  <div class="agenda-page-header">
    <div class="agenda-page-header-text">
      <h1 class="agenda-page-header-title">Agenda do Lavador</h1>
      <p class="agenda-page-header-subtitle">Consulte a programação e a disponibilidade do lavador.</p>
    </div>
    <div class="agenda-page-header-controls">
      <AgendaDateNavigator />
      <AgendaViewSelector />
    </div>
  </div>
</template>

<script setup lang="ts">
import AgendaDateNavigator from './AgendaDateNavigator.vue'
import AgendaViewSelector from './AgendaViewSelector.vue'
</script>

<style scoped>
.agenda-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 24px;
  gap: 24px;
  flex-wrap: wrap;
}

.agenda-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.agenda-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.agenda-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.agenda-page-header-controls {
  display: flex;
  align-items: center;
  gap: 16px;
}

@media (max-width: 768px) {
  .agenda-page-header {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>