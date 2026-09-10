<template>
  <div class="jornada-lavador-empty-state">
    <ClockIcon class="jornada-lavador-empty-state-icon" aria-hidden="true" />
    <h3 class="jornada-lavador-empty-state-title">Nenhuma jornada cadastrada</h3>
    <p class="jornada-lavador-empty-state-desc">Cadastre uma jornada para configurar o funcionamento do lavador.</p>
    <button
      type="button"
      class="jornada-lavador-empty-state-btn"
      @click="$emit('new-jornada')"
    >
      <PlusIcon class="jornada-lavador-empty-state-btn-icon" aria-hidden="true" />
      Nova Jornada
    </button>
  </div>
</template>

<script setup lang="ts">
import { ClockIcon, PlusIcon } from '@heroicons/vue/24/outline'

defineEmits<{
  'new-jornada': []
}>()
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

.jornada-lavador-empty-state-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, box-shadow 0.2s;
}

.jornada-lavador-empty-state-btn:hover {
  background-color: #003570;
}

.jornada-lavador-empty-state-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.jornada-lavador-empty-state-btn-icon {
  width: 18px;
  height: 18px;
}
</style>
