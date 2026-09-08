<template>
  <div class="dashboard-content">
    <ProximasReservasCard />
    <UtilizacaoLavadorCard
      regime="NORMAL"
      :capacidade-total="480"
      :tempo-utilizado="180"
      :disponivel="300"
      :percentual-utilizado="37.5"
    />
  </div>
</template>

<script setup lang="ts">
import UtilizacaoLavadorCard from './UtilizacaoLavadorCard.vue'
import ProximasReservasCard from './ProximasReservasCard.vue'
</script>

<style scoped>
.dashboard-content {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
  margin-bottom: 8px;
}

@media (max-width: 1024px) {
  .dashboard-content {
    grid-template-columns: 1fr;
  }
}
</style>