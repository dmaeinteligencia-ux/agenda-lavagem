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
        <button type="button" class="tipos-veiculo-acao-btn" title="Editar" aria-label="Editar tipo">
          <PencilSquareIcon aria-hidden="true" />
        </button>
        <button type="button" class="tipos-veiculo-acao-btn" title="Excluir" aria-label="Excluir tipo">
          <XMarkIcon aria-hidden="true" />
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import { PencilSquareIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import type { TipoVeiculoMock } from '@/utils/tiposVeiculoMock'

interface Props {
  tipo: TipoVeiculoMock
}

defineProps<Props>()
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

.tipos-veiculo-acao-btn:hover {
  background: #f3f4f6;
  color: #004790;
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