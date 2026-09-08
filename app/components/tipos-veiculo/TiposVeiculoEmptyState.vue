<template>
  <div class="tipos-veiculo-empty-state">
    <TruckIcon class="tipos-veiculo-empty-state-icon" aria-hidden="true" />
    <h3 class="tipos-veiculo-empty-state-title">Nenhum tipo de veículo cadastrado</h3>
    <p class="tipos-veiculo-empty-state-desc">Os tipos de veículos cadastrados aparecerão aqui.</p>
  </div>
</template>

<script setup lang="ts">
import { TruckIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.tipos-veiculo-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  text-align: center;
}

.tipos-veiculo-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.tipos-veiculo-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.tipos-veiculo-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}
</style>