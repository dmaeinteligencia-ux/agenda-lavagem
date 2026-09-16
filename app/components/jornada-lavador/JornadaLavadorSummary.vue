<template>
  <div class="jornada-lavador-summary">
    <AgendaSummaryCard
      title="Regimes configurados"
      :value="String(summary.regimesConfigurados)"
      description="Jornadas operacionais"
      :icon="ClipboardDocumentCheckIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Jornada normal"
      :value="formatarHoras(summary.horasNormal)"
      description="Segunda a sexta-feira"
      :icon="ClockIcon"
      variant="amber"
    />
    <AgendaSummaryCard
      title="Jornada plantão"
      :value="formatarHoras(summary.horasPlantao)"
      description="Sábados, domingos e feriados"
      :icon="CalendarDaysIcon"
      variant="amber"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { ClipboardDocumentCheckIcon, ClockIcon, CalendarDaysIcon } from '@heroicons/vue/24/outline'
import type { ResumoJornada } from '@/utils/jornadaLavador'

interface Props {
  summary: ResumoJornada
}

defineProps<Props>()

const formatarHoras = (horas: number | null): string => (horas === null ? '—' : `${horas}h`)
</script>

<style scoped>
.jornada-lavador-summary {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .jornada-lavador-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .jornada-lavador-summary {
    grid-template-columns: 1fr;
  }
}
</style>
