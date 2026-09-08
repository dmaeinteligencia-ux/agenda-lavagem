<template>
  <tr class="veiculo-row">
    <td class="veiculo-cell veiculo-cell--id" data-label="Identificação">
      <div class="veiculo-id-block">
        <TruckIcon class="veiculo-cell-icon" aria-hidden="true" />
        <strong class="veiculo-id">{{ veiculo.identification }}</strong>
      </div>
    </td>
    <td class="veiculo-cell" data-label="Placa">
      <span class="veiculo-plate">{{ veiculo.plate }}</span>
    </td>
    <td class="veiculo-cell" data-label="Tipo">
      <span>{{ veiculo.type }}</span>
    </td>
    <td class="veiculo-cell" data-label="Equipamento">
      <span class="veiculo-equipment">{{ veiculo.equipment }}</span>
    </td>
    <td class="veiculo-cell" data-label="Situação">
      <VeiculoStatusBadge :situacao="veiculo.situacao" />
    </td>
    <td class="veiculo-cell veiculo-cell--actions" data-label="Ações">
      <div class="veiculo-actions">
        <button type="button" class="veiculo-action-btn" title="Visualizar" aria-label="Visualizar veículo">
          <EyeIcon aria-hidden="true" />
        </button>
        <button type="button" class="veiculo-action-btn" title="Editar" aria-label="Editar veículo">
          <PencilSquareIcon aria-hidden="true" />
        </button>
        <button type="button" class="veiculo-action-btn" title="Mais ações" aria-label="Mais ações">
          <EllipsisVerticalIcon aria-hidden="true" />
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import { TruckIcon, EyeIcon, PencilSquareIcon, EllipsisVerticalIcon } from '@heroicons/vue/24/outline'
import VeiculoStatusBadge from './VeiculoStatusBadge.vue'
import type { VeiculoMock } from '@/utils/veiculosMock'

interface Props {
  veiculo: VeiculoMock
}

defineProps<Props>()
</script>

<style scoped>
.veiculo-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.veiculo-row:hover {
  background-color: #f8fafc;
}

.veiculo-row:last-child {
  border-bottom: none;
}

.veiculo-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
}

.veiculo-cell-icon {
  width: 18px;
  height: 18px;
  color: #6b7280;
  flex-shrink: 0;
}

.veiculo-id-block {
  display: flex;
  align-items: center;
  gap: 10px;
}

.veiculo-id {
  font-size: 15px;
  font-weight: 700;
  color: #111827;
  letter-spacing: 0.02em;
}

.veiculo-plate {
  font-weight: 600;
  color: #004790;
  letter-spacing: 0.02em;
}

.veiculo-equipment {
  display: inline-flex;
  padding: 3px 10px;
  background: #f3f4f6;
  color: #4b5563;
  border-radius: 6px;
  font-family: 'Courier New', monospace;
  font-size: 12px;
  font-weight: 600;
}

.veiculo-cell--actions {
  text-align: right;
}

.veiculo-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
}

.veiculo-action-btn {
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

.veiculo-action-btn:hover {
  background: #f3f4f6;
  color: #004790;
}

.veiculo-action-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.veiculo-action-btn svg {
  width: 18px;
  height: 18px;
}

@media (max-width: 768px) {
  .veiculo-row {
    display: block;
    padding: 14px 16px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    margin-bottom: 12px;
    background: #fff;
  }

  .veiculo-cell {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 0;
    font-size: 13px;
  }

  .veiculo-cell::before {
    content: attr(data-label);
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca3af;
    flex-shrink: 0;
  }

  .veiculo-cell--actions {
    justify-content: flex-start;
    padding-top: 12px;
    margin-top: 4px;
    border-top: 1px solid #f1f5f9;
  }

  .veiculo-cell--id {
    padding-bottom: 4px;
  }

  .veiculo-cell--id::before {
    display: none;
  }

  .veiculo-id {
    font-size: 16px;
  }
}
</style>