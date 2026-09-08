<template>
  <div class="reservas-pagination">
    <span class="reservas-pagination-info">Exibindo 1–10 de 24 resultados</span>
    <div class="reservas-pagination-controls">
      <button type="button" class="reservas-pagination-btn" disabled>
        <ChevronLeftIcon aria-hidden="true" />
        <span>Anterior</span>
      </button>
      <div class="reservas-pagination-pages">
        <button type="button" class="reservas-pagination-page reservas-pagination-page--active">1</button>
        <button type="button" class="reservas-pagination-page">2</button>
        <button type="button" class="reservas-pagination-page">3</button>
        <span class="reservas-pagination-ellipsis">…</span>
      </div>
      <button type="button" class="reservas-pagination-btn">
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
.reservas-pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-top: 1px solid #f1f5f9;
  background: #fff;
  flex-wrap: wrap;
  gap: 12px;
}

.reservas-pagination-info {
  font-size: 13px;
  color: #6b7280;
}

.reservas-pagination-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.reservas-pagination-btn {
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

.reservas-pagination-btn:hover:not(:disabled) {
  background: #f9fafb;
  border-color: #d1d5db;
}

.reservas-pagination-btn:disabled {
  color: #cbd5e1;
  cursor: not-allowed;
}

.reservas-pagination-btn svg {
  width: 16px;
  height: 16px;
}

.reservas-pagination-pages {
  display: flex;
  align-items: center;
  gap: 4px;
}

.reservas-pagination-page {
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

.reservas-pagination-page:hover {
  background: #f3f4f6;
}

.reservas-pagination-page--active {
  background: #004790;
  color: #fff;
  border-color: #004790;
}

.reservas-pagination-page--active:hover {
  background: #003570;
  border-color: #003570;
}

.reservas-pagination-ellipsis {
  padding: 0 4px;
  color: #9ca3af;
}

@media (max-width: 600px) {
  .reservas-pagination {
    flex-direction: column;
    align-items: stretch;
  }

  .reservas-pagination-info {
    text-align: center;
  }

  .reservas-pagination-controls {
    justify-content: center;
    flex-wrap: wrap;
  }
}
</style>