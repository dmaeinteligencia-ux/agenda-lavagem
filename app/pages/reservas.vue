<template>
  <div class="reservas-page">
    <ReservasPageHeader />
    <ReservasSummary :summary="summary" />
    <ReservasFilters />
    <ReservasTable />
  </div>
</template>

<script setup lang="ts">
import ReservasPageHeader from '@/components/reservas/ReservasPageHeader.vue'
import ReservasSummary from '@/components/reservas/ReservasSummary.vue'
import ReservasFilters from '@/components/reservas/ReservasFilters.vue'
import ReservasTable from '@/components/reservas/ReservasTable.vue'
import { reservasSummary } from '@/utils/reservasMock'

const summary = reservasSummary

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.reservas-page {
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
  .reservas-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .reservas-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>