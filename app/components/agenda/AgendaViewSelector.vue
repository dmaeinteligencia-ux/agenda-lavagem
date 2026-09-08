<template>
  <div class="agenda-view-selector">
    <button
      v-for="view in views"
      :key="view"
      class="view-btn"
      :class="{ 'view-btn--active': view === activeView }"
    >
      {{ view }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const views = ['Dia', 'Semana']
const activeView = ref('Dia')
</script>

<style scoped>
.agenda-view-selector {
  display: flex;
  background: #f0f4f8;
  border-radius: 8px;
  padding: 3px;
  gap: 2px;
}

.view-btn {
  padding: 6px 14px;
  font-size: 13px;
  font-weight: 500;
  color: #6b7280;
  background: transparent;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
}

.view-btn:hover {
  color: #1f2937;
}

.view-btn--active {
  background: #fff;
  color: #004790;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
}
</style>