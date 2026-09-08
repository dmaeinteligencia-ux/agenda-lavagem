<template>
  <div class="veiculo-form-section">
    <h4 class="veiculo-form-section-title">Identificação</h4>
    <div class="veiculo-form-grid">
      <BaseInput label="Código do equipamento" placeholder="Digite o código do equipamento" />
      <div class="veiculo-form-field">
        <label class="veiculo-form-label">Tipo de veículo</label>
        <div class="veiculo-form-select-wrap">
          <input
            type="text"
            class="veiculo-form-input"
            placeholder="Selecione o tipo"
            readonly
          />
          <ChevronDownIcon class="veiculo-form-select-icon" aria-hidden="true" />
        </div>
      </div>
      <BaseInput label="Classificação da frota" placeholder="Digite a classificação" />
      <BaseInput label="Número da frota" placeholder="Digite o número" />
    </div>

    <div class="veiculo-form-info">
      <span class="veiculo-form-info-label">Identificação da frota</span>
      <strong class="veiculo-form-info-value">A11</strong>
    </div>
  </div>
</template>

<script setup lang="ts">
import BaseInput from '@/components/BaseInput.vue'
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
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

.veiculo-form-input::placeholder {
  color: #9ca3af;
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

.veiculo-form-info {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #dbeafe;
  border: 1px solid #bfdbfe;
  border-radius: 8px;
}

.veiculo-form-info-label {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #1e40af;
}

.veiculo-form-info-value {
  font-size: 20px;
  font-weight: 700;
  color: #004790;
  letter-spacing: 0.02em;
}

@media (max-width: 600px) {
  .veiculo-form-grid {
    grid-template-columns: 1fr;
  }
}
</style>