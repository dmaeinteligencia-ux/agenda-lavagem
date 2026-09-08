<template>
  <div class="tipos-veiculo-page">
    <TiposVeiculoPageHeader />
    <TiposVeiculoSummary :summary="summary" />
    <TiposVeiculoSearch />
    <TiposVeiculoFilters />
    <TiposVeiculoTable />
  </div>
</template>

<script setup lang="ts">
import TiposVeiculoPageHeader from '@/components/tipos-veiculo/TiposVeiculoPageHeader.vue'
import TiposVeiculoSummary from '@/components/tipos-veiculo/TiposVeiculoSummary.vue'
import TiposVeiculoSearch from '@/components/tipos-veiculo/TiposVeiculoSearch.vue'
import TiposVeiculoFilters from '@/components/tipos-veiculo/TiposVeiculoFilters.vue'
import TiposVeiculoTable from '@/components/tipos-veiculo/TiposVeiculoTable.vue'
import { tiposVeiculoSummary } from '@/utils/tiposVeiculoMock'

const summary = tiposVeiculoSummary

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.tipos-veiculo-page {
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
  .tipos-veiculo-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .tipos-veiculo-page {
    padding: 16px 12;
    gap: 16px;
  }
}
</style>