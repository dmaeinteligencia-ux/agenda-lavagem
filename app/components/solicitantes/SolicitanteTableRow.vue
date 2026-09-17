<template>
  <tr class="solicitante-row">
    <td class="solicitante-cell solicitante-cell--matricula" data-label="Matrícula">
      <span class="solicitante-matricula">{{ solicitante.matricula }}</span>
    </td>
    <td class="solicitante-cell" data-label="Nome">
      <span>{{ solicitante.nome }}</span>
    </td>
    <td class="solicitante-cell" data-label="Telefone">
      <span>{{ solicitante.telefone }}</span>
    </td>
    <td class="solicitante-cell solicitante-cell--acoes" data-label="Ações">
      <div class="solicitante-acoes">
        <button
          type="button"
          class="solicitante-acao-btn"
          title="Editar"
          aria-label="Editar solicitante"
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
import type { Solicitante } from '@/utils/solicitantes'

interface Props {
  solicitante: Solicitante
}

defineProps<Props>()

defineEmits<{
  edit: []
}>()
</script>

<style scoped>
.solicitante-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.solicitante-row:hover {
  background-color: #f8fafc;
}

.solicitante-row:last-child {
  border-bottom: none;
}

.solicitante-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
  white-space: nowrap;
}

.solicitante-cell--matricula {
  font-weight: 600;
  color: #111827;
}

.solicitante-matricula {
  font-weight: 600;
  color: #004790;
}

.solicitante-cell--acoes {
  text-align: right;
}

.solicitante-acoes {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
}

.solicitante-acao-btn {
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

.solicitante-acao-btn:hover {
  background: #f3f4f6;
  color: #004790;
}

.solicitante-acao-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.solicitante-acao-btn svg {
  width: 18px;
  height: 18px;
}

@media (max-width: 768px) {
  .solicitante-row {
    display: block;
    padding: 14px 16px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    margin-bottom: 12px;
    background: #fff;
  }

  .solicitante-cell {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 0;
    font-size: 13px;
    white-space: normal;
  }

  .solicitante-cell::before {
    content: attr(data-label);
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca3af;
    flex-shrink: 0;
    margin-right: 16px;
  }

  .solicitante-cell--matricula::before {
    display: none;
  }

  .solicitante-cell--acoes {
    justify-content: flex-start;
    padding-top: 12px;
    margin-top: 4px;
    border-top: 1px solid #f1f5f9;
  }

  .solicitante-cell--acoes::before {
    display: none;
  }
}
</style>
