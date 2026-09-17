<template>
  <div class="relatorio-empty-state">
    <ChartBarIcon class="relatorio-empty-state-icon" aria-hidden="true" />
    <h3 class="relatorio-empty-state-title">{{ title }}</h3>
    <p v-if="description" class="relatorio-empty-state-desc">{{ description }}</p>
  </div>
</template>

<script setup lang="ts">
import { ChartBarIcon } from '@heroicons/vue/24/outline'

interface Props {
  title: string
  description?: string
}

withDefaults(defineProps<Props>(), {
  description: ''
})
</script>

<style scoped>
.relatorio-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  text-align: center;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.relatorio-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.relatorio-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.relatorio-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}
</style>
