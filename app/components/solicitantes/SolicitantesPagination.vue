<template>
  <div class="solicitantes-pagination">
    <span class="solicitantes-pagination-info">Exibindo 1–{{ total }} de {{ total }} solicitantes</span>
    <div class="solicitantes-pagination-controls">
      <button type="button" class="solicitantes-pagination-btn" disabled>
        <ChevronLeftIcon aria-hidden="true" />
        <span>Anterior</span>
      </button>
      <div class="solicitantes-pagination-pages">
        <button type="button" class="solicitantes-pagination-page solicitantes-pagination-page--active">1</button>
      </div>
      <button type="button" class="solicitantes-pagination-btn" disabled>
        <span>Próxima</span>
        <ChevronRightIcon aria-hidden="true" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/vue/24/outline'

interface Props {
  total: number
}

defineProps<Props>()
</script>

<style scoped>
.solicitantes-pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-top: 1px solid #f1f5f9;
  background: #fff;
  flex-wrap: wrap;
  gap: 12px;
}

.solicitantes-pagination-info {
  font-size: 13px;
  color: #6b7280;
}

.solicitantes-pagination-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.solicitantes-pagination-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 14px;
  font-size: 13px;
  font-weight: 500;
  color: #374151;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.15s, border-color 0.15s;
}

.solicitantes-pagination-btn:hover:not(:disabled) {
  background: #f9fafb;
  border-color: #d1d5db;
}

.solicitantes-pagination-btn:disabled {
  color: #cbd5e1;
  cursor: not-allowed;
}

.solicitantes-pagination-btn svg {
  width: 16px;
  height: 16px;
}

.solicitantes-pagination-pages {
  display: flex;
  align-items: center;
  gap: 4px;
}

.solicitantes-pagination-page {
  min-width: 32px;
  height: 32px;
  padding: 0 10px;
  font-size: 13px;
  font-weight: 600;
  color: #374151;
  background: #fff;
  border: 1px solid transparent;
  border-radius: 6px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.15s, color 0.15s, border-color 0.15s;
}

.solicitantes-pagination-page--active {
  background: #004790;
  color: #fff;
  border-color: #004790;
}

@media (max-width: 600px) {
  .solicitantes-pagination {
    flex-direction: column;
    align-items: stretch;
  }

  .solicitantes-pagination-info {
    text-align: center;
  }

  .solicitantes-pagination-controls {
    justify-content: center;
    flex-wrap: wrap;
  }
}
</style>
