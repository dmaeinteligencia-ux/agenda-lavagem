<template>
  <div class="summary-cards">
    <SummaryCard
      title="Reservas Hoje"
      value="12"
      description="4 em andamento"
      :icon="CalendarDaysIcon"
      variant="blue"
    />
    <SummaryCard
      title="Capacidade"
      value="480 min"
      description="total do dia"
      :icon="ClockIcon"
      variant="amber"
    />
    <SummaryCard
      title="Utilizado"
      value="240 min"
      description="50% da capacidade"
      :icon="ChartBarIcon"
      variant="green"
    />
    <SummaryCard
      title="Disponível"
      value="240 min"
      description="restante"
      :icon="CheckCircleIcon"
      variant="green"
    />
  </div>
</template>

<script setup lang="ts">
import { CalendarDaysIcon, ClockIcon, ChartBarIcon, CheckCircleIcon } from '@heroicons/vue/24/outline'
import SummaryCard from './SummaryCard.vue'
</script>

<style scoped>
.summary-cards {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 20px;
  margin-bottom: 24px;
}

@media (max-width: 1024px) {
  .summary-cards {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 600px) {
  .summary-cards {
    grid-template-columns: 1fr;
  }
}
</style>