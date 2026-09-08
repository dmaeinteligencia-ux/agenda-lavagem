<template>
  <tr class="reserva-row">
    <td class="reserva-cell reserva-cell--vehicle">
      <span class="reserva-vehicle-id">{{ reserva.vehicle }}</span>
    </td>
    <td class="reserva-cell">
      <span class="reserva-plate">{{ reserva.plate }}</span>
    </td>
    <td class="reserva-cell">
      <span>{{ reserva.type }}</span>
    </td>
    <td class="reserva-cell">
      <span class="reserva-date">{{ reserva.date }}</span>
    </td>
    <td class="reserva-cell">
      <span class="reserva-regime" :class="`reserva-regime--${reserva.regime.toLowerCase()}`">
        {{ reserva.regime === 'PLANTAO' ? 'PLANTÃO' : reserva.regime }}
      </span>
    </td>
    <td class="reserva-cell">
      <span>{{ reserva.time }}</span>
    </td>
    <td class="reserva-cell">
      <AgendaStatusBadge :status="reserva.status" />
    </td>
    <td class="reserva-cell reserva-cell--actions">
      <div class="reserva-actions">
        <button type="button" class="reserva-action-btn" title="Visualizar" aria-label="Visualizar reserva">
          <EyeIcon aria-hidden="true" />
        </button>
        <button type="button" class="reserva-action-btn" title="Editar" aria-label="Editar reserva">
          <PencilSquareIcon aria-hidden="true" />
        </button>
        <button type="button" class="reserva-action-btn reserva-action-btn--danger" title="Cancelar" aria-label="Cancelar reserva">
          <XMarkIcon aria-hidden="true" />
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import AgendaStatusBadge from '@/components/agenda/AgendaStatusBadge.vue'
import { EyeIcon, PencilSquareIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import type { ReservaMock } from '@/utils/reservasMock'

interface Props {
  reserva: ReservaMock
}

defineProps<Props>()
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

.reserva-date {
  color: #4b5563;
}

.reserva-regime {
  display: inline-flex;
  padding: 3px 10px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.04em;
}

.reserva-regime--normal {
  background: #f3f4f6;
  color: #4b5563;
}

.reserva-regime--plantao {
  background: #fef3c7;
  color: #92400e;
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

.reserva-action-btn:hover {
  background: #f3f4f6;
  color: #004790;
}

.reserva-action-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.reserva-action-btn--danger:hover {
  background: #fee2e2;
  color: #dc2626;
}

.reserva-action-btn svg {
  width: 18px;
  height: 18px;
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