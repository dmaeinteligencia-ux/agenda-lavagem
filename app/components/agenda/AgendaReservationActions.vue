<template>
  <div class="agenda-reservation-actions">
    <button
      v-for="acao in acoes"
      :key="acao.chave"
      type="button"
      class="agenda-action-btn"
      :class="`agenda-action-btn--${acao.variante}`"
      :disabled="loading"
      @click="$emit('acao', acao.chave)"
    >
      <span v-if="loading" class="agenda-action-spinner" aria-hidden="true" />
      <span>{{ acao.label }}</span>
    </button>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import {
  acoesParaReserva,
  type AcaoChave,
  type AcaoReserva,
  type ReservaStatus
} from '@/utils/reservas'
import type { Perfil } from '@/utils/accessControl'

interface Props {
  status: ReservaStatus
  perfil: Perfil | null
  temAcesso: boolean
  loading: boolean
}

const props = defineProps<Props>()

defineEmits<{
  acao: [chave: AcaoChave]
}>()

const acoes = computed<AcaoReserva[]>(() =>
  acoesParaReserva(props.status, props.perfil, props.temAcesso)
)
</script>

<style scoped>
.agenda-reservation-actions {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-wrap: wrap;
}

.agenda-action-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  font-size: 12px;
  font-weight: 600;
  border-radius: 6px;
  border: 1px solid transparent;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.15s;
}

.agenda-action-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.agenda-action-btn--default {
  background: #eff6ff;
  color: #1d4ed8;
}

.agenda-action-btn--default:hover:not(:disabled) {
  background: #dbeafe;
}

.agenda-action-btn--danger {
  background: #fee2e2;
  color: #991b1b;
}

.agenda-action-btn--danger:hover:not(:disabled) {
  background: #fecaca;
}

.agenda-action-btn--warning {
  background: #fef3c7;
  color: #92400e;
}

.agenda-action-btn--warning:hover:not(:disabled) {
  background: #fde68a;
}

.agenda-action-spinner {
  width: 12px;
  height: 12px;
  border: 2px solid rgba(0, 71, 144, 0.25);
  border-top-color: #004790;
  border-radius: 50%;
  animation: agenda-action-spin 0.6s linear infinite;
}

@keyframes agenda-action-spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
