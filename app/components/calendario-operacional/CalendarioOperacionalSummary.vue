<template>
  <div class="calendario-operacional-summary">
    <AgendaSummaryCard
      title="Total de Configurações"
      :value="summary.total"
      description="Datas específicas cadastradas"
      :icon="CalendarDaysIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Datas em NORMAL"
      :value="summary.normal"
      description="Configurações específicas"
      :icon="SunIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Datas em PLANTÃO"
      :value="summary.plantao"
      description="Configurações específicas"
      :icon="MoonIcon"
      variant="amber"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { CalendarDaysIcon, SunIcon, MoonIcon } from '@heroicons/vue/24/outline'

interface CalendarioOperacionalSummaryData {
  total: string
  normal: string
  plantao: string
}

interface Props {
  summary: CalendarioOperacionalSummaryData
}

defineProps<Props>()
</script>

<style scoped>
.calendario-operacional-summary {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .calendario-operacional-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .calendario-operacional-summary {
    grid-template-columns: 1fr;
  }
}
</style>
