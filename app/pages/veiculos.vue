<template>
  <div class="veiculos-page">
    <VeiculosPageHeader @new-veiculo="showModal = true" />
    <VeiculosSummary :summary="summary" />
    <VeiculosSearch />
    <VeiculosFilters />
    <VeiculosTable />

    <VeiculoModal v-if="showModal" mode="create" @close="showModal = false" />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import VeiculosPageHeader from '@/components/veiculos/VeiculosPageHeader.vue'
import VeiculosSummary from '@/components/veiculos/VeiculosSummary.vue'
import VeiculosSearch from '@/components/veiculos/VeiculosSearch.vue'
import VeiculosFilters from '@/components/veiculos/VeiculosFilters.vue'
import VeiculosTable from '@/components/veiculos/VeiculosTable.vue'
import VeiculoModal from '@/components/veiculos/VeiculoModal.vue'
import { veiculosSummary } from '@/utils/veiculosMock'

const summary = veiculosSummary
const showModal = ref(false)

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.veiculos-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

@media (max-width: 1024px) {
  .veiculos-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .veiculos-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>