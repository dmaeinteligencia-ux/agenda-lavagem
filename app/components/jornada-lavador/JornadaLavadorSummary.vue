<template>
  <div class="jornada-lavador-summary">
    <AgendaSummaryCard
      title="Regimes configurados"
      :value="summary.regimesConfigurados"
      description="Jornadas operacionais"
      :icon="ClipboardDocumentCheckIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Jornada normal"
      :value="summary.jornadaNormal"
      description="Segunda a sexta-feira"
      :icon="ClockIcon"
      variant="amber"
    />
    <AgendaSummaryCard
      title="Plantão"
      :value="plantaoValue"
      description="para agendamento"
      :icon="CalendarDaysIcon"
      :variant="plantaoVariant"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { ClipboardDocumentCheckIcon, ClockIcon, CalendarDaysIcon } from '@heroicons/vue/24/outline'

interface JornadaLavadorSummaryData {
  regimesConfigurados: string
  jornadaNormal: string
  plantaoDisponivel: boolean
}

interface Props {
  summary: JornadaLavadorSummaryData
}

const props = defineProps<Props>()

const plantaoValue = computed(() =>
  props.summary.plantaoDisponivel ? 'Disponível' : 'Indisponível'
)

const plantaoVariant = computed(() =>
  props.summary.plantaoDisponivel ? 'green' : 'red'
)
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
