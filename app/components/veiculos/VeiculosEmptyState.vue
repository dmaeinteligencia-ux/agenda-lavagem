<template>
  <div class="veiculos-empty-state">
    <TruckIcon class="veiculos-empty-state-icon" aria-hidden="true" />
    <h3 class="veiculos-empty-state-title">{{ title }}</h3>
    <p class="veiculos-empty-state-desc">{{ description }}</p>
  </div>
</template>

<script setup lang="ts">
import { TruckIcon } from '@heroicons/vue/24/outline'

interface Props {
  title?: string
  description?: string
}

withDefaults(defineProps<Props>(), {
  title: 'Não há veículos cadastrados',
  description: 'Os veículos cadastrados na frota aparecerão aqui.'
})
</script>

<style scoped>
.veiculos-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  text-align: center;
}

.veiculos-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.veiculos-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.veiculos-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}
</style>
