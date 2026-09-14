<template>
  <tr class="calendario-operacional-row">
    <td class="calendario-operacional-cell calendario-operacional-cell--data" data-label="Data">
      <span class="calendario-operacional-data">{{ formatarData(configuracao.data) }}</span>
    </td>
    <td class="calendario-operacional-cell" data-label="Dia da Semana">
      <span>{{ getDiaSemana(configuracao.data) }}</span>
    </td>
    <td class="calendario-operacional-cell" data-label="Regime">
      <span class="calendario-operacional-regime" :class="`calendario-operacional-regime--${configuracao.regime.toLowerCase()}`">
        {{ configuracao.regime }}
      </span>
    </td>
    <td class="calendario-operacional-cell" data-label="Observação">
      <span class="calendario-operacional-observacao">{{ configuracao.observacao || '—' }}</span>
    </td>
    <td class="calendario-operacional-cell calendario-operacional-cell--acoes" data-label="Ações">
      <div class="calendario-operacional-acoes">
        <button
          type="button"
          class="calendario-operacional-acao-btn"
          title="Editar"
          aria-label="Editar configuração"
          @click="$emit('edit')"
        >
          <PencilSquareIcon aria-hidden="true" />
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import { PencilSquareIcon } from '@heroicons/vue/24/outline'
import { getDiaSemana, formatarData } from '@/utils/calendarioOperacionalMock'
import type { CalendarioOperacionalMock } from '@/utils/calendarioOperacionalMock'

interface Props {
  configuracao: CalendarioOperacionalMock
}

defineProps<Props>()

defineEmits<{
  edit: []
}>()
</script>

<style scoped>
.calendario-operacional-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.calendario-operacional-row:hover {
  background-color: #f8fafc;
}

.calendario-operacional-row:last-child {
  border-bottom: none;
}

.calendario-operacional-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
  white-space: nowrap;
}

.calendario-operacional-data {
  font-weight: 600;
  color: #111827;
}

.calendario-operacional-regime {
  display: inline-flex;
  padding: 3px 10px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.04em;
}

.calendario-operacional-regime--normal {
  background: #dbeafe;
  color: #1e40af;
}

.calendario-operacional-regime--plantao {
  background: #fef3c7;
  color: #92400e;
}

.calendario-operacional-observacao {
  color: #4b5563;
}

.calendario-operacional-cell--acoes {
  text-align: right;
}

.calendario-operacional-acoes {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
}

.calendario-operacional-acao-btn {
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

.calendario-operacional-acao-btn:hover {
  background: #f3f4f6;
  color: #004790;
}

.calendario-operacional-acao-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.calendario-operacional-acao-btn svg {
  width: 18px;
  height: 18px;
}

@media (max-width: 768px) {
  .calendario-operacional-row {
    display: block;
    padding: 14px 16px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    margin-bottom: 12px;
    background: #fff;
  }

  .calendario-operacional-cell {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 0;
    font-size: 13px;
    white-space: normal;
  }

  .calendario-operacional-cell::before {
    content: attr(data-label);
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca3af;
    flex-shrink: 0;
    margin-right: 16px;
  }

  .calendario-operacional-cell--data::before {
    display: none;
  }

  .calendario-operacional-cell--acoes {
    justify-content: flex-start;
    padding-top: 12px;
    margin-top: 4px;
    border-top: 1px solid #f1f5f9;
  }

  .calendario-operacional-cell--acoes::before {
    display: none;
  }
}
</style>
