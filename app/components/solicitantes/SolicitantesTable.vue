<template>
  <div class="solicitantes-table-wrapper">
    <div class="solicitantes-table-container">
      <table class="solicitantes-table">
        <thead>
          <tr class="solicitantes-header">
            <th class="solicitantes-header-cell">Matrícula</th>
            <th class="solicitantes-header-cell">Nome</th>
            <th class="solicitantes-header-cell">Telefone</th>
            <th class="solicitantes-header-cell solicitantes-header-cell--acoes">Ações</th>
          </tr>
        </thead>
        <tbody>
          <SolicitanteTableRow
            v-for="solicitante in solicitantes"
            :key="solicitante.id"
            :solicitante="solicitante"
            @edit="$emit('edit', solicitante)"
          />
        </tbody>
      </table>
    </div>
  </div>

  <SolicitantesEmptyState
    v-if="solicitantes.length === 0"
    :variant="hasSolicitantes ? 'search' : 'empty'"
    @new-solicitante="$emit('new-solicitante')"
  />
</template>

<script setup lang="ts">
import SolicitanteTableRow from './SolicitanteTableRow.vue'
import SolicitantesEmptyState from './SolicitantesEmptyState.vue'
import type { Solicitante } from '@/utils/solicitantes'

interface Props {
  solicitantes: Solicitante[]
  hasSolicitantes: boolean
}

defineProps<Props>()

defineEmits<{
  edit: [solicitante: Solicitante]
  'new-solicitante': []
}>()
</script>

<style scoped>
.solicitantes-table-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.solicitantes-table-container {
  overflow-x: auto;
}

.solicitantes-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 600px;
}

.solicitantes-header {
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}

.solicitantes-header-cell {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.solicitantes-header-cell--acoes {
  text-align: right;
  width: 100px;
}

@media (max-width: 768px) {
  .solicitantes-table {
    min-width: 0;
  }

  .solicitantes-header {
    display: none;
  }
}
</style>
