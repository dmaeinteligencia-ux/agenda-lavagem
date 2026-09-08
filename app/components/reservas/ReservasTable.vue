<template>
  <div class="reservas-table-wrapper">
    <div class="reservas-table-container">
      <table class="reservas-table">
        <thead>
          <tr class="reservas-header">
            <th class="reservas-header-cell">Veículo</th>
            <th class="reservas-header-cell">Placa</th>
            <th class="reservas-header-cell">Tipo</th>
            <th class="reservas-header-cell">Data</th>
            <th class="reservas-header-cell">Regime</th>
            <th class="reservas-header-cell">Tempo</th>
            <th class="reservas-header-cell">Status</th>
            <th class="reservas-header-cell reservas-header-cell--actions">Ações</th>
          </tr>
        </thead>
        <tbody>
          <ReservaTableRow v-for="reserva in reservas" :key="reserva.id" :reserva="reserva" />
        </tbody>
      </table>
    </div>

    <ReservasPagination />
  </div>

  <ReservasEmptyState v-if="reservas.length === 0" />
</template>

<script setup lang="ts">
import ReservaTableRow from './ReservaTableRow.vue'
import ReservasPagination from './ReservasPagination.vue'
import ReservasEmptyState from './ReservasEmptyState.vue'
import { reservasMock } from '@/utils/reservasMock'

const reservas = reservasMock
</script>

<style scoped>
.reservas-table-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.reservas-table-container {
  overflow-x: auto;
}

.reservas-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 1200px;
}

.reservas-header {
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}

.reservas-header-cell {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.reservas-header-cell--actions {
  text-align: right;
  width: 120px;
}

@media (max-width: 768px) {
  .reservas-table {
    min-width: 0;
  }

  .reservas-header {
    display: none;
  }
}
</style>