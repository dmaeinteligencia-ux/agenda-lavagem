<template>
  <div class="veiculos-table-wrapper">
    <div class="veiculos-table-container">
      <table class="veiculos-table">
        <thead>
          <tr class="veiculos-header">
            <th class="veiculos-header-cell">Identificação</th>
            <th class="veiculos-header-cell">Placa</th>
            <th class="veiculos-header-cell">Tipo</th>
            <th class="veiculos-header-cell">Equipamento</th>
            <th class="veiculos-header-cell">Situação</th>
            <th class="veiculos-header-cell veiculos-header-cell--actions">Ações</th>
          </tr>
        </thead>
        <tbody>
          <VeiculoTableRow v-for="veiculo in veiculos" :key="veiculo.id" :veiculo="veiculo" />
        </tbody>
      </table>
    </div>

    <VeiculosPagination />
  </div>

  <VeiculosEmptyState v-if="veiculos.length === 0" />
</template>

<script setup lang="ts">
import VeiculoTableRow from './VeiculoTableRow.vue'
import VeiculosPagination from './VeiculosPagination.vue'
import VeiculosEmptyState from './VeiculosEmptyState.vue'
import { veiculosMock } from '@/utils/veiculosMock'

const veiculos = veiculosMock
</script>

<style scoped>
.veiculos-table-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.veiculos-table-container {
  overflow-x: auto;
}

.veiculos-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 1000px;
}

.veiculos-header {
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}

.veiculos-header-cell {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.veiculos-header-cell--actions {
  text-align: right;
  width: 130px;
}

@media (max-width: 768px) {
  .veiculos-table {
    min-width: 0;
  }

  .veiculos-header {
    display: none;
  }
}
</style>