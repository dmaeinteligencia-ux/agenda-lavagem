<template>
  <tr class="reserva-row">
    <td class="reserva-cell reserva-cell--vehicle" data-label="Veículo">
      <span class="reserva-vehicle-id">{{ reserva.veiculo }}</span>
    </td>
    <td class="reserva-cell" data-label="Placa">
      <span class="reserva-plate">{{ reserva.placa }}</span>
    </td>
    <td class="reserva-cell" data-label="Tipo">
      <span>{{ reserva.tipo }}</span>
    </td>
    <td class="reserva-cell" data-label="Solicitante">
      <span class="reserva-solicitante-nome">{{ reserva.solicitante }}</span>
    </td>
    <td class="reserva-cell" data-label="Data">
      <span class="reserva-date">{{ formatarDataCurta(reserva.data) }}</span>
    </td>
    <td class="reserva-cell" data-label="Tempo">
      <span>{{ reserva.tempoEstimado }} min</span>
    </td>
    <td class="reserva-cell" data-label="Status">
      <AgendaStatusBadge :status="reserva.status" />
    </td>
    <td class="reserva-cell reserva-cell--actions" data-label="Ações">
      <div class="reserva-actions">
        <button
          type="button"
          class="reserva-action-btn"
          title="Visualizar"
          aria-label="Visualizar reserva"
          @click="$emit('visualizar', reserva)"
        >
          <EyeIcon aria-hidden="true" />
        </button>
        <button
          v-if="podeCancelar"
          type="button"
          class="reserva-action-btn reserva-action-btn--danger"
          title="Cancelar"
          aria-label="Cancelar reserva"
          :disabled="cancelando"
          @click="$emit('cancelar', reserva)"
        >
          <span v-if="cancelando" class="reserva-action-spinner" aria-hidden="true" />
          <XMarkIcon v-else aria-hidden="true" />
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import AgendaStatusBadge from '@/components/agenda/AgendaStatusBadge.vue'
import { EyeIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import { formatarDataCurta, type ReservaAdmin } from '@/utils/reservasAdmin'

interface Props {
  reserva: ReservaAdmin
  podeCancelar: boolean
  cancelando: boolean
}

defineProps<Props>()

defineEmits<{
  visualizar: [reserva: ReservaAdmin]
  cancelar: [reserva: ReservaAdmin]
}>()
</script>

<style scoped>
.reserva-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.reserva-row:hover {
  background-color: #f8fafc;
}

.reserva-row:last-child {
  border-bottom: none;
}

.reserva-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
}

.reserva-cell--vehicle {
  font-weight: 600;
  color: #111827;
}

.reserva-vehicle-id {
  display: block;
}

.reserva-plate {
  font-weight: 600;
  color: #004790;
  letter-spacing: 0.02em;
}

.reserva-solicitante-nome {
  font-weight: 500;
  color: #1f2937;
}

.reserva-date {
  color: #4b5563;
}

.reserva-cell--actions {
  text-align: right;
}

.reserva-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
}

.reserva-action-btn {
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

.reserva-action-btn:hover:not(:disabled) {
  background: #f3f4f6;
  color: #004790;
}

.reserva-action-btn:disabled {
  cursor: not-allowed;
  opacity: 0.6;
}

.reserva-action-btn--danger:hover:not(:disabled) {
  background: #fee2e2;
  color: #dc2626;
}

.reserva-action-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.reserva-action-btn svg {
  width: 18px;
  height: 18px;
}

.reserva-action-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid #fecaca;
  border-top-color: #dc2626;
  border-radius: 50%;
  animation: reserva-action-spin 0.7s linear infinite;
}

@keyframes reserva-action-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 768px) {
  .reserva-row {
    display: block;
    padding: 14px 16px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    margin-bottom: 12px;
    background: #fff;
  }

  .reserva-cell {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 0;
    font-size: 13px;
  }

  .reserva-cell::before {
    content: attr(data-label);
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca3af;
    flex-shrink: 0;
  }

  .reserva-cell--actions {
    justify-content: flex-start;
    padding-top: 12px;
    margin-top: 4px;
    border-top: 1px solid #f1f5f9;
  }

  .reserva-cell--vehicle {
    padding-bottom: 4px;
  }

  .reserva-cell--vehicle::before {
    display: none;
  }

  .reserva-vehicle-id {
    font-size: 16px;
    font-weight: 700;
    color: #111827;
  }
}
</style>
