<template>
  <div class="reservas-summary">
    <AgendaSummaryCard
      title="Total"
      :value="summary.total"
      description="Reservas no período"
      :icon="ClipboardIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Reservadas"
      :value="summary.reserved"
      description="Agendadas"
      :icon="CalendarIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Em Lavagem"
      :value="summary.washing"
      description="Em execução"
      :icon="BoltIcon"
      variant="amber"
    />
    <AgendaSummaryCard
      title="Concluídas"
      :value="summary.completed"
      description="Finalizadas"
      :icon="CheckCircleIcon"
      variant="green"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { ClipboardDocumentListIcon, CalendarDaysIcon, BoltIcon, CheckCircleIcon } from '@heroicons/vue/24/outline'

interface ReservasSummaryData {
  total: string
  reserved: string
  washing: string
  completed: string
}

interface Props {
  summary: ReservasSummaryData
}

defineProps<Props>()
</script>

<style scoped>
.reservas-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .reservas-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .reservas-summary {
    grid-template-columns: 1fr;
  }
}
</style>