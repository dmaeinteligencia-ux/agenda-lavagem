<template>
  <div class="jornada-lavador-summary">
    <AgendaSummaryCard
      title="Regimes Cadastrados"
      :value="summary.total_regimes"
      description="Regimes definidos no sistema"
      :icon="TruckIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Capacidade Configurada"
      :value="jornadaLavadorSummary.regula_configuradas"
      description="Horas totais configuradas"
      :icon="CubeIcon"
      variant="amber"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { TruckIcon, CubeIcon } from '@heroicons/vue/24/outline'

interface JornadaLavadorSummaryData {
  total_regimes: string
  regulas_configuradas: string
}

interface Props {
  summary: JornadaLavadorSummaryData
}

defineProps<Props>()

const jornadaLavadorSummary = {
  total_regimes: '2',
  regulas_configuradas: '2'
}
</script>

<style scoped>
.jornada-lavador-summary {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .jornada-lavador-summary {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .jornada-lavador-summary {
    grid-template-columns: 1fr;
  }
}
</style>