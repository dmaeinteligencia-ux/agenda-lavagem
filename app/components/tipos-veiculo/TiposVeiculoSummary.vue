<template>
  <div class="tipos-veiculo-summary">
    <AgendaSummaryCard
      title="Tipos de veículo"
      :value="String(summary.total)"
      description="Cadastrados no sistema"
      :icon="CubeIcon"
      variant="blue"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { CubeIcon } from '@heroicons/vue/24/outline'

interface TiposVeiculoSummaryData {
  total: number
}

interface Props {
  summary: TiposVeiculoSummaryData
}

defineProps<Props>()
</script>

<style scoped>
.tipos-veiculo-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .tipos-veiculo-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .tipos-veiculo-summary {
    grid-template-columns: 1fr;
  }
}
</style>
