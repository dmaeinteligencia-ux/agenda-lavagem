<template>
  <div class="jornada-lavador-pagination">
    <span class="jornada-lavador-pagination-info">Exibindo 1–2 de 2 regimes</span>
    <div class="jornada-lavador-pagination-controls">
      <button type="button" class="jornada-lavador-pagination-btn" disabled>
        <ChevronLeftIcon aria-hidden="true" />
        <span>Anterior</span>
      </button>
      <div class="jornada-lavador-pagination-pages">
        <button type="button" class="jornada-lavador-pagination-page jornad a-lavador-pagination-page--active">1</button>
        <span class="jornada-lavador-pagination-ellipsis">…</span>
      </div>
      <button type="button" class="jornada-lavador-pagination-btn">
        <span>Próxima</span>
        <ChevronRightIcon aria-hidden="true" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.jornada-lavador-pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-top: 1px solid #f1f5f9;
  background: #fff;
  flex-wrap: wrap;
  gap: 12px;
}

.jornada-lavador-pagination-info {
  font-size: 13px;
  color: #6b7280;
}

.jornada-lavador-pagination-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.jornada-lavador-pagination-btn {
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

.jornada-lavador-pagination-btn:hover:not(:disabled) {
  background: #f9fafb;
  border-color: #d1d5db;
}

.jornada-lavador-pagination-btn:disabled {
  color: #cbd5e1;
  cursor: not-allowed;
}

.jornada-lavador-pagination-btn svg {
  width: 16px;
  height: 16px;
}

.jornada-lavador-pagination-pages {
  display: flex;
  align-items: center;
  gap: 4px;
}

.jornada-lavador-pagination-page {
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

.jornada-lavador-pagination-page:hover {
  background: #f3f4f6;
}

.jornada-lavador-pagination-page--active {
  background: #004790;
  color: #fff;
  border-color: #004790;
}

.jornada-lavador-pagination-page--active:hover {
  background: #003570;
  border-color: #003570;
}

.jornada-lavador-pagination-ellipsis {
  padding: 0 4px;
  color: #9ca3af;
}

@media (max-width: 600px) {
  .jornada-lavador-pagination {
    flex-direction: column;
    align-items: stretch;
  }

  .jornada-lavador-pagination-info {
    text-align: center;
  }

  .jornada-lavador-pagination-controls {
    justify-content: center;
    flex-wrap: wrap;
  }
}
</style>