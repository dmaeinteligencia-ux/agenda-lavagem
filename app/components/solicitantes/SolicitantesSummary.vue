<template>
  <div class="solicitantes-summary">
    <AgendaSummaryCard
      title="Total de Solicitantes"
      :value="summary.total"
      description="Cadastrados no sistema"
      :icon="UserGroupIcon"
      variant="blue"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { UserGroupIcon } from '@heroicons/vue/24/outline'

interface SolicitantesSummaryData {
  total: string
}

interface Props {
  summary: SolicitantesSummaryData
}

defineProps<Props>()
</script>

<style scoped>
.solicitantes-summary {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .solicitantes-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .solicitantes-summary {
    grid-template-columns: 1fr;
  }
}
</style>
