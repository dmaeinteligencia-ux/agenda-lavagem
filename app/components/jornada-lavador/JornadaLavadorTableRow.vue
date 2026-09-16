<template>
  <tr class="jornada-lavador-row">
    <td class="jornada-lavador-cell jornada-lavador-cell--regime" data-label="Regime">
      <span class="jornada-lavador-regime-badge" :class="`jornada-lavador-regime-badge--${jornada.regime.toLowerCase()}`">
        {{ jornada.regime }}
      </span>
    </td>
    <td class="jornada-lavador-cell" data-label="Dias de aplicação">
      <span>{{ diasPorRegime(jornada.regime) }}</span>
    </td>
    <td class="jornada-lavador-cell" data-label="Horas disponíveis">
      <span>{{ jornada.horas_disponiveis }}h</span>
    </td>
    <td class="jornada-lavador-cell jornada-lavador-cell--acoes" data-label="Ações">
      <div class="jornada-lavador-acoes">
        <button
          type="button"
          class="jornada-lavador-acao-btn"
          title="Editar"
          aria-label="Editar jornada"
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
import { diasPorRegime, type JornadaLavador } from '@/utils/jornadaLavador'

interface Props {
  jornada: JornadaLavador
}

defineProps<Props>()

defineEmits<{
  edit: []
}>()
</script>

<style scoped>
.jornada-lavador-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.jornada-lavador-row:hover {
  background-color: #f8fafc;
}

.jornada-lavador-row:last-child {
  border-bottom: none;
}

.jornada-lavador-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
  white-space: nowrap;
}

.jornada-lavador-regime-badge {
  display: inline-flex;
  align-items: center;
  padding: 3px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.02em;
  width: fit-content;
}

.jornada-lavador-regime-badge--normal {
  background: #dbeafe;
  color: #1e40af;
}

.jornada-lavador-regime-badge--plantao {
  background: #fef3c7;
  color: #92400e;
}

.jornada-lavador-cell--acoes {
  text-align: right;
}

.jornada-lavador-acoes {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
}

.jornada-lavador-acao-btn {
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

.jornada-lavador-acao-btn:hover {
  background: #f3f4f6;
  color: #004790;
}

.jornada-lavador-acao-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.jornada-lavador-acao-btn svg {
  width: 18px;
  height: 18px;
}

@media (max-width: 768px) {
  .jornada-lavador-row {
    display: block;
    padding: 14px 16px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    margin-bottom: 12px;
    background: #fff;
  }

  .jornada-lavador-cell {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 0;
    font-size: 13px;
    white-space: normal;
  }

  .jornada-lavador-cell::before {
    content: attr(data-label);
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca3af;
    flex-shrink: 0;
    margin-right: 16px;
  }

  .jornada-lavador-cell--regime::before {
    display: none;
  }

  .jornada-lavador-cell--acoes {
    justify-content: flex-start;
    padding-top: 12px;
    margin-top: 4px;
    border-top: 1px solid #f1f5f9;
  }

  .jornada-lavador-cell--acoes::before {
    display: none;
  }
}
</style>
