<template>
  <div class="agenda-summary">
    <AgendaSummaryCard
      title="Capacidade"
      value="480 min"
      description="8h disponíveis"
      :icon="ClockIcon"
      variant="amber"
    />
    <AgendaSummaryCard
      title="Utilizado"
      value="312 min"
      description="65% da capacidade"
      :icon="ChartBarIcon"
      variant="red"
    />
    <AgendaSummaryCard
      title="Disponível"
      value="168 min"
      description="2h 48min restantes"
      :icon="CheckCircleIcon"
      variant="green"
    />
    <AgendaSummaryCard
      title="Reservas"
      value="4"
      description="Programadas hoje"
      :icon="CalendarDaysIcon"
      variant="blue"
    />
  </div>
</template>

<script setup lang="ts">
import { ClockIcon, ChartBarIcon, CheckCircleIcon, CalendarDaysIcon } from '@heroicons/vue/24/outline'
import AgendaSummaryCard from './AgendaSummaryCard.vue'
</script>

<style scoped>
.agenda-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

@media (max-width: 1024px) {
  .agenda-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .agenda-summary {
    grid-template-columns: 1fr;
  }
}
</style>