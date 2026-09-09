<template>
  <tr class="jornada-lavador-table-row">
    <td class="jornada-lavador-table-cell">
      <span class="jornada-lavador-table-cell-regime">
        {{ jornada.regime === 'NORMAL' ? 'NORMAL' : 'PLANTAO' }}
      </span>
    </td>
    <td class="jornada-lavador-table-cell">
      <span class="jornada-lavador-table-cell-horas">
        {{ jornada.horas_disponiveis }} horas
      </span>
    </td>
    <td class="jornada-lavador-table-cell">
      <button type="button" class="jornada-lavador-table-cell-acao-btn" title="Editar" aria-label="Editar jornada" @click="$emit('edit', jornada)">
        <PencilSquareIcon aria-hidden="true" />
      </button>
    </td>
  </tr>
</template>

<script setup lang="ts">
import { PencilSquareIcon } from '@heroicons/vue/24/outline'
import type { JornadaLavador } from '@/utils/jornadaLavadorMock'

interface Props {
  jornada: JornadaLavador
}

const emit = defineEmits(['edit'])
defineProps<Props>()
</script>

<style scoped>
.jornada-lavador-table-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.jornada-lavador-table-row:hover {
  background-color: #f8fafc;
}

.jornada-lavador-table-row:last-child {
  border-bottom: none;
}

.jornada-lavador-table-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
  white-space: nowrap;
}

.jornada-lavador-table-cell-regime {
  font-weight: 600;
  color: #111827;
}

.jornada-lavador-table-cell-horas {
  font-weight: 600;
  color: #004790;
}

.jornada-lavador-table-cell-acao-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 6px;
  background: transparent;
  color: #6b7280;
  cursor: pointer;
  transition: background-color 0.15s, color 0.15s;
}

.jornada-lavador-table-cell-acao-btn:hover {
  background: #f3f4f6;
  color: #004790;
}

.jornada-lavador-table-cell-acao-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.jornada-lavador-table-cell-acao-btn svg {
  width: 18px;
  height: 18px;
}
</style>