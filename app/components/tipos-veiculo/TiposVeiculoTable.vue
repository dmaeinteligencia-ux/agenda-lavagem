<template>
  <div class="tipos-veiculo-table-wrapper">
    <div class="tipos-veiculo-table-container">
      <table class="tipos-veiculo-table">
        <thead>
          <tr class="tipos-veiculo-header">
            <th class="tipos-veiculo-header-cell">Tipo de Veículo</th>
            <th class="tipos-veiculo-header-cell">Tempo de Lavagem</th>
            <th class="tipos-veiculo-header-cell tipos-veiculo-header-cell--acoes">Ações</th>
          </tr>
        </thead>
        <tbody>
          <TipoVeiculoTableRow v-for="tipo in tipos" :key="tipo.id" :tipo="tipo" />
        </tbody>
      </table>
    </div>

    <TiposVeiculoPagination />
  </div>

  <TiposVeiculoEmptyState v-if="tipos.length === 0" />
</template>

<script setup lang="ts">
import TipoVeiculoTableRow from './TipoVeiculoTableRow.vue'
import TiposVeiculoPagination from './TiposVeiculoPagination.vue'
import TiposVeiculoEmptyState from './TiposVeiculoEmptyState.vue'
import { tiposVeiculoMock } from '@/utils/tiposVeiculoMock'

const tipos = tiposVeiculoMock
</script>

<style scoped>
.tipos-veiculo-table-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.tipos-veiculo-table-container {
  overflow-x: auto;
}

.tipos-veiculo-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 600px;
}

.tipos-veiculo-header {
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}

.tipos-veiculo-header-cell {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.tipos-veiculo-header-cell--acoes {
  text-align: right;
  width: 130px;
}

@media (max-width: 768px) {
  .tipos-veiculo-table {
    min-width: 0;
  }

  .tipos-veiculo-header {
    display: none;
  }
}
</style>