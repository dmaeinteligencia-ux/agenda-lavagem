<template>
  <div class="veiculo-form-section">
    <h4 class="veiculo-form-section-title">Dados do veículo</h4>
    <div class="veiculo-form-grid">
      <BaseInput
        label="Modelo"
        placeholder="Ex: Atego 1719"
        :model-value="form.ds_modelo"
        :disabled="readonly"
        @update:model-value="form.ds_modelo = $event"
      />
      <BaseInput
        label="Ano"
        type="number"
        placeholder="Ex: 2022"
        :model-value="form.ano"
        :disabled="readonly"
        @update:model-value="form.ano = $event"
      />
      <div class="veiculo-form-field">
        <label class="veiculo-form-label" for="veiculo-combustivel">Combustível</label>
        <div class="veiculo-form-select-wrap">
          <select
            id="veiculo-combustivel"
            class="veiculo-form-input"
            :value="form.ds_combustivel"
            :disabled="readonly"
            @change="form.ds_combustivel = ($event.target as HTMLSelectElement).value"
          >
            <option value="">Não informado</option>
            <option v-for="item in combustiveis" :key="item" :value="item">{{ item }}</option>
          </select>
          <ChevronDownIcon class="veiculo-form-select-icon" aria-hidden="true" />
        </div>
      </div>
      <BaseInput
        label="Placa"
        placeholder="Ex: ABC1A23"
        :model-value="form.nr_placa_transport"
        :disabled="readonly"
        @update:model-value="form.nr_placa_transport = $event"
      />
      <div class="veiculo-form-field">
        <label class="veiculo-form-label" for="veiculo-situacao">Situação</label>
        <div class="veiculo-form-select-wrap">
          <select
            id="veiculo-situacao"
            class="veiculo-form-input"
            :value="form.ativo ? 'ATIVO' : 'INATIVO'"
            :disabled="readonly"
            @change="form.ativo = ($event.target as HTMLSelectElement).value === 'ATIVO'"
          >
            <option value="ATIVO">Ativo</option>
            <option value="INATIVO">Inativo</option>
          </select>
          <ChevronDownIcon class="veiculo-form-select-icon" aria-hidden="true" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import BaseInput from '@/components/BaseInput.vue'
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
import type { VeiculoFormData } from '@/utils/veiculos'

interface Props {
  form: VeiculoFormData
  readonly?: boolean
}

withDefaults(defineProps<Props>(), {
  readonly: false
})

const combustiveis = ['FLEX', 'GASOLINA', 'DIESEL']
</script>

<style scoped>
.veiculo-form-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.veiculo-form-section-title {
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #6b7280;
  margin: 0;
  padding-bottom: 8px;
  border-bottom: 1px solid #e5e7eb;
}

.veiculo-form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.veiculo-form-field {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.veiculo-form-label {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.veiculo-form-select-wrap {
  position: relative;
}

.veiculo-form-input {
  width: 100%;
  padding: 10px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 2px solid #d1d5db;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  font-family: inherit;
  appearance: none;
  padding-right: 36px;
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.veiculo-form-input:disabled {
  background: #f9fafb;
  color: #6b7280;
  cursor: not-allowed;
}

.veiculo-form-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.veiculo-form-select-icon {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  width: 16px;
  height: 16px;
  color: #6b7280;
  pointer-events: none;
}

@media (max-width: 600px) {
  .veiculo-form-grid {
    grid-template-columns: 1fr;
  }
}
</style>
