<template>
  <div class="calendario-operacional-pagination">
    <span class="calendario-operacional-pagination-info">Exibindo 1–{{ total }} de {{ total }} configurações</span>
    <div class="calendario-operacional-pagination-controls">
      <button type="button" class="calendario-operacional-pagination-btn" disabled>
        <ChevronLeftIcon aria-hidden="true" />
        <span>Anterior</span>
      </button>
      <div class="calendario-operacional-pagination-pages">
        <button type="button" class="calendario-operacional-pagination-page calendario-operacional-pagination-page--active">1</button>
      </div>
      <button type="button" class="calendario-operacional-pagination-btn" disabled>
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
.calendario-operacional-pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-top: 1px solid #f1f5f9;
  background: #fff;
  flex-wrap: wrap;
  gap: 12px;
}

.calendario-operacional-pagination-info {
  font-size: 13px;
  color: #6b7280;
}

.calendario-operacional-pagination-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.calendario-operacional-pagination-btn {
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

.calendario-operacional-pagination-btn:hover:not(:disabled) {
  background: #f9fafb;
  border-color: #d1d5db;
}

.calendario-operacional-pagination-btn:disabled {
  color: #cbd5e1;
  cursor: not-allowed;
}

.calendario-operacional-pagination-btn svg {
  width: 16px;
  height: 16px;
}

.calendario-operacional-pagination-pages {
  display: flex;
  align-items: center;
  gap: 4px;
}

.calendario-operacional-pagination-page {
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

.calendario-operacional-pagination-page--active {
  background: #004790;
  color: #fff;
  border-color: #004790;
}

@media (max-width: 600px) {
  .calendario-operacional-pagination {
    flex-direction: column;
    align-items: stretch;
  }

  .calendario-operacional-pagination-info {
    text-align: center;
  }

  .calendario-operacional-pagination-controls {
    justify-content: center;
    flex-wrap: wrap;
  }
}
</style>
