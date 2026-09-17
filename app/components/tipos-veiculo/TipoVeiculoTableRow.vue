<template>
  <tr class="tipos-veiculo-row">
    <td class="tipos-veiculo-cell tipos-veiculo-cell--tipo">
      <span>{{ tipo.descricao }}</span>
    </td>
    <td class="tipos-veiculo-cell">
      <span>{{ tipo.tempo_min }} min</span>
    </td>
    <td class="tipos-veiculo-cell tipos-veiculo-cell--acoes">
      <div class="tipos-veiculo-acoes">
        <button
          type="button"
          class="tipos-veiculo-acao-btn"
          title="Editar"
          aria-label="Editar tipo"
          @click="$emit('editar', tipo)"
        >
          <PencilSquareIcon aria-hidden="true" />
        </button>
        <button
          type="button"
          class="tipos-veiculo-acao-btn tipos-veiculo-acao-btn--danger"
          title="Excluir"
          aria-label="Excluir tipo"
          :disabled="excluindo"
          @click="$emit('excluir', tipo)"
        >
          <span v-if="excluindo" class="tipos-veiculo-acao-spinner" aria-hidden="true" />
          <XMarkIcon v-else aria-hidden="true" />
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import { PencilSquareIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import type { TipoVeiculo } from '@/utils/tiposVeiculo'

interface Props {
  tipo: TipoVeiculo
  excluindo: boolean
}

defineProps<Props>()

defineEmits<{
  editar: [tipo: TipoVeiculo]
  excluir: [tipo: TipoVeiculo]
}>()
</script>

<style scoped>
.tipos-veiculo-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.tipos-veiculo-row:hover {
  background-color: #f8fafc;
}

.tipos-veiculo-row:last-child {
  border-bottom: none;
}

.tipos-veiculo-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
  white-space: nowrap;
}

.tipos-veiculo-cell--tipo {
  font-weight: 600;
  color: #111827;
}

.tipos-veiculo-cell--acoes {
  text-align: right;
}

.tipos-veiculo-acao-btn {
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

.tipos-veiculo-acao-btn:hover:not(:disabled) {
  background: #f3f4f6;
  color: #004790;
}

.tipos-veiculo-acao-btn:disabled {
  cursor: not-allowed;
  opacity: 0.6;
}

.tipos-veiculo-acao-btn--danger:hover:not(:disabled) {
  background: #fee2e2;
  color: #b91c1c;
}

.tipos-veiculo-acao-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid #fecaca;
  border-top-color: #dc2626;
  border-radius: 50%;
  animation: tipos-veiculo-acao-spin 0.7s linear infinite;
}

@keyframes tipos-veiculo-acao-spin {
  to {
    transform: rotate(360deg);
  }
}

.tipos-veiculo-acao-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.tipos-veiculo-acao-btn svg {
  width: 18px;
  height: 18px;
}

@media (max-width: 768px) {
  .tipos-veiculo-row {
    display: block;
    padding: 14px 16px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    margin-bottom: 12px;
    background: #fff;
  }

  .tipos-veiculo-cell {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 0;
    font-size: 13px;
  }

  .tipos-veiculo-cell--tipo {
    padding-bottom: 4px;
  }

  .tipos-veiculo-cell--tipo::before {
    display: none;
  }

  .tipos-veiculo-cell--acoes {
    justify-content: flex-start;
    padding-top: 12px;
    margin-top: 4px;
    border-top: 1px solid #f1f5f9;
  }
}
</style>