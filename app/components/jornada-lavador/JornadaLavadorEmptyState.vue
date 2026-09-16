<template>
  <div class="jornada-lavador-empty-state">
    <ClockIcon class="jornada-lavador-empty-state-icon" aria-hidden="true" />
    <h3 class="jornada-lavador-empty-state-title">Nenhuma jornada configurada</h3>
    <p class="jornada-lavador-empty-state-desc">
      As jornadas dos regimes NORMAL e PLANTÃO devem estar configuradas no sistema.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ClockIcon } from '@heroicons/vue/24/outline'
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
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
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
