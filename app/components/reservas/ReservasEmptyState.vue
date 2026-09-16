<template>
  <div class="reservas-empty-state">
    <CalendarDaysIcon class="reservas-empty-state-icon" aria-hidden="true" />
    <h3 class="reservas-empty-state-title">{{ title }}</h3>
    <p class="reservas-empty-state-desc">{{ description }}</p>
  </div>
</template>

<script setup lang="ts">
import { CalendarDaysIcon } from '@heroicons/vue/24/outline'

interface Props {
  title?: string
  description?: string
}

withDefaults(defineProps<Props>(), {
  title: 'Não há reservas encontradas',
  description: 'Quando houver reservas cadastradas, elas aparecerão aqui.'
})
</script>

<style scoped>
.reservas-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  text-align: center;
}

.reservas-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.reservas-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.reservas-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}
</style>