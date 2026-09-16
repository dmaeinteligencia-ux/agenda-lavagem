<template>
  <div class="jornada-lavador-table-wrapper">
    <div class="jornada-lavador-table-container">
      <table class="jornada-lavador-table">
        <thead>
          <tr class="jornada-lavador-header">
            <th class="jornada-lavador-header-cell">Regime</th>
            <th class="jornada-lavador-header-cell">Dias de aplicação</th>
            <th class="jornada-lavador-header-cell">Horas disponíveis</th>
            <th class="jornada-lavador-header-cell jornada-lavador-header-cell--acoes">Ações</th>
          </tr>
        </thead>
        <tbody>
          <JornadaLavadorTableRow
            v-for="jornada in jornadas"
            :key="jornada.id"
            :jornada="jornada"
            @edit="$emit('edit', jornada)"
          />
        </tbody>
      </table>
    </div>
  </div>

  <JornadaLavadorEmptyState v-if="jornadas.length === 0" />
</template>

<script setup lang="ts">
import JornadaLavadorTableRow from './JornadaLavadorTableRow.vue'
import JornadaLavadorEmptyState from './JornadaLavadorEmptyState.vue'
import type { JornadaLavador } from '@/utils/jornadaLavador'

interface Props {
  jornadas: JornadaLavador[]
}

defineProps<Props>()

defineEmits<{
  edit: [jornada: JornadaLavador]
}>()
</script>

<style scoped>
.jornada-lavador-table-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.jornada-lavador-table-container {
  overflow-x: auto;
}

.jornada-lavador-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 760px;
}

.jornada-lavador-header {
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}

.jornada-lavador-header-cell {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.jornada-lavador-header-cell--acoes {
  text-align: right;
  width: 100px;
}

@media (max-width: 768px) {
  .jornada-lavador-table {
    min-width: 0;
  }

  .jornada-lavador-header {
    display: none;
  }
}
</style>
