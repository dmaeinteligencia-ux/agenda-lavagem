<template>
  <div class="agenda-summary">
    <AgendaSummaryCard
      title="Capacidade"
      :value="`${capacidade} min`"
      description="Jornada do dia"
      :icon="ClockIcon"
      variant="amber"
    />
    <AgendaSummaryCard
      title="Utilizado"
      :value="`${utilizado} min`"
      :description="percentualDescricao"
      :icon="ChartBarIcon"
      variant="red"
    />
    <AgendaSummaryCard
      title="Disponível"
      :value="`${disponivel} min`"
      description="Restantes"
      :icon="CheckCircleIcon"
      variant="green"
    />
    <AgendaSummaryCard
      title="Reservas"
      :value="String(reservas)"
      description="Programadas no dia"
      :icon="CalendarDaysIcon"
      variant="blue"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ClockIcon, ChartBarIcon, CheckCircleIcon, CalendarDaysIcon } from '@heroicons/vue/24/outline'
import AgendaSummaryCard from './AgendaSummaryCard.vue'

interface Props {
  capacidade: number
  utilizado: number
  disponivel: number
  reservas: number
}

const props = defineProps<Props>()

const percentualDescricao = computed(() => {
  if (props.capacidade <= 0) {
    return '—'
  }
  const pct = Math.round((props.utilizado / props.capacidade) * 100)
  return `${pct}% da capacidade`
})
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
