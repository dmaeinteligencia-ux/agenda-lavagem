<template>
  <div class="tipos-veiculo-summary">
    <AgendaSummaryCard
      title="Total de Tipos"
      :value="summary.total"
      description="Na frota"
      :icon="TruckIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Tipos Configurados"
      :value="summary.tipos"
      description="Cadastrados no sistema"
      :icon="CubeIcon"
      variant="amber"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { TruckIcon, CubeIcon } from '@heroicons/vue/24/outline'

interface TiposVeiculoSummaryData {
  total: string
  tipos: string
}

interface Props {
  summary: TiposVeiculoSummaryData
}

defineProps<Props>()
</script>

<style scoped>
.tipos-veiculo-summary {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
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