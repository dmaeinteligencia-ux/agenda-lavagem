<template>
  <div class="veiculos-summary">
    <AgendaSummaryCard
      title="Total de Veículos"
      :value="String(summary.total)"
      description="Na frota"
      :icon="TruckIcon"
      variant="blue"
    />
    <AgendaSummaryCard
      title="Ativos"
      :value="String(summary.ativos)"
      description="Disponíveis"
      :icon="CheckCircleIcon"
      variant="green"
    />
    <AgendaSummaryCard
      title="Inativos"
      :value="String(summary.inativos)"
      description="Fora de serviço"
      :icon="XMarkIcon"
      variant="red"
    />
    <AgendaSummaryCard
      title="Tipos de Veículo"
      :value="String(summary.tipos)"
      description="Categorias"
      :icon="CubeIcon"
      variant="amber"
    />
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import { TruckIcon, CheckCircleIcon, XMarkIcon, CubeIcon } from '@heroicons/vue/24/outline'

interface VeiculosSummaryData {
  total: number
  ativos: number
  inativos: number
  tipos: number
}

interface Props {
  summary: VeiculosSummaryData
}

defineProps<Props>()
</script>

<style scoped>
.veiculos-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .veiculos-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .veiculos-summary {
    grid-template-columns: 1fr;
  }
}
</style>
