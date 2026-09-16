<template>
  <div class="calendario-operacional-summary">
    <AgendaSummaryCard
      title="Configurações do mês"
      :value="String(summary.configuracoes)"
      description="Exceções cadastradas"
      :icon="CalendarDaysIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Plantões manuais"
      :value="String(summary.plantoes)"
      description="Exceções em PLANTÃO"
      :icon="MoonIcon"
      variant="amber"
    />
    <AgendaSummaryCard
      title="Dias sem atendimento"
      :value="String(summary.semAtendimento)"
      description="Exceções inativas"
      :icon="XCircleIcon"
      variant="red"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { CalendarDaysIcon, MoonIcon, XCircleIcon } from '@heroicons/vue/24/outline'
import type { ResumoCalendario } from '@/utils/calendarioOperacional'

interface Props {
  summary: ResumoCalendario
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
