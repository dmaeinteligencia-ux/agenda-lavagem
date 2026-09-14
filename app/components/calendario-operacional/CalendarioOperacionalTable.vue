<template>
  <div class="calendario-operacional-table-wrapper">
    <div class="calendario-operacional-table-container">
      <table class="calendario-operacional-table">
        <thead>
          <tr class="calendario-operacional-header">
            <th class="calendario-operacional-header-cell">Data</th>
            <th class="calendario-operacional-header-cell">Dia da Semana</th>
            <th class="calendario-operacional-header-cell">Regime</th>
            <th class="calendario-operacional-header-cell">Observação</th>
            <th class="calendario-operacional-header-cell calendario-operacional-header-cell--acoes">Ações</th>
          </tr>
        </thead>
        <tbody>
          <CalendarioOperacionalTableRow
            v-for="configuracao in configuracoes"
            :key="configuracao.id"
            :configuracao="configuracao"
            @edit="$emit('edit', configuracao)"
          />
        </tbody>
      </table>
    </div>

    <CalendarioOperacionalPagination :total="configuracoes.length" />
  </div>

  <CalendarioOperacionalEmptyState
    v-if="configuracoes.length === 0"
    :variant="hasConfiguracoes ? 'search' : 'empty'"
    @new-configuracao="$emit('new-configuracao')"
  />
</template>

<script setup lang="ts">
import CalendarioOperacionalTableRow from './CalendarioOperacionalTableRow.vue'
import CalendarioOperacionalPagination from './CalendarioOperacionalPagination.vue'
import CalendarioOperacionalEmptyState from './CalendarioOperacionalEmptyState.vue'
import type { CalendarioOperacionalMock } from '@/utils/calendarioOperacionalMock'

interface Props {
  configuracoes: CalendarioOperacionalMock[]
  hasConfiguracoes: boolean
}

defineProps<Props>()

defineEmits<{
  edit: [configuracao: CalendarioOperacionalMock]
  'new-configuracao': []
}>()
</script>

<style scoped>
.calendario-operacional-table-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.calendario-operacional-table-container {
  overflow-x: auto;
}

.calendario-operacional-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 760px;
}

.calendario-operacional-header {
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}

.calendario-operacional-header-cell {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.calendario-operacional-header-cell--acoes {
  text-align: right;
  width: 100px;
}

@media (max-width: 768px) {
  .calendario-operacional-table {
    min-width: 0;
  }

  .calendario-operacional-header {
    display: none;
  }
}
</style>
