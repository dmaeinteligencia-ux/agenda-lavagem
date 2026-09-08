<template>
  <div class="jornada-lavador-empty-state">
    <TruckIcon class="jornada-lavador-empty-state-icon" aria-hidden="true" />
    <h3 class="jornada-lavador-empty-state-title">Nenhuma jornada cadastrada</h3>
    <p class="jornada-lavador-empty-state-desc">As jornadas cadastradas aparecerão aqui.</p>
  </div>
</template>

<script setup lang="ts">
import { TruckIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.jornada-lavador-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  text-align: center;
}

.jornada-lavador-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.jornada-lavador-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.jornada-lavador-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}
</style>