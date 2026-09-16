<template>
  <section class="nova-reserva-card" aria-labelledby="nova-reserva-summary-title">
    <header class="nova-reserva-card-header">
      <h2 id="nova-reserva-summary-title" class="nova-reserva-card-title">
        <span class="nova-reserva-card-step" aria-hidden="true">5</span>
        Resumo da reserva
      </h2>
    </header>
    <div class="nova-reserva-summary-body">
      <dl class="nova-reserva-summary-list">
        <div class="nova-reserva-summary-row">
          <dt>Veículo</dt>
          <dd>{{ vehicle.identification }}</dd>
        </div>
        <div class="nova-reserva-summary-row">
          <dt>Placa</dt>
          <dd>{{ vehicle.plate }}</dd>
        </div>
        <div class="nova-reserva-summary-row">
          <dt>Tipo</dt>
          <dd>{{ vehicle.type }}</dd>
        </div>
        <div class="nova-reserva-summary-row">
          <dt>Data</dt>
          <dd>{{ date }}</dd>
        </div>
        <div class="nova-reserva-summary-row">
          <dt>Regime</dt>
          <dd>
            <span class="nova-reserva-summary-regime">{{ regime }}</span>
          </dd>
        </div>
        <div class="nova-reserva-summary-row">
          <dt>Tempo estimado</dt>
          <dd>{{ estimatedTime }}</dd>
        </div>
      </dl>

      <div class="nova-reserva-summary-observation">
        <label for="nova-reserva-observation" class="nova-reserva-summary-observation-label">
          Observação
        </label>
        <textarea
          id="nova-reserva-observation"
          class="nova-reserva-summary-observation-input"
          rows="3"
          placeholder="Digite uma observação, se necessário."
          :value="observacao"
          @input="$emit('update:observacao', ($event.target as HTMLTextAreaElement).value)"
        />
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import type { NovaReservaVehicle } from '@/utils/reservas'

interface Props {
  vehicle: NovaReservaVehicle
  date: string
  regime: string
  estimatedTime: string
  observacao: string
}

defineProps<Props>()

defineEmits<{
  'update:observacao': [value: string]
}>()
</script>

<style scoped>
.nova-reserva-card {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.nova-reserva-card-header {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-bottom: 20px;
}

.nova-reserva-card-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 0;
  font-size: 17px;
  font-weight: 700;
  color: #111827;
}

.nova-reserva-card-step {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 26px;
  height: 26px;
  border-radius: 50%;
  background: #dbeafe;
  color: #004790;
  font-size: 13px;
  font-weight: 700;
  flex-shrink: 0;
}

.nova-reserva-summary-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.nova-reserva-summary-list {
  margin: 0;
  display: flex;
  flex-direction: column;
}

.nova-reserva-summary-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 11px 0;
  border-bottom: 1px solid #f3f4f6;
}

.nova-reserva-summary-row:last-child {
  border-bottom: none;
}

.nova-reserva-summary-row dt {
  font-size: 14px;
  color: #6b7280;
}

.nova-reserva-summary-row dd {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #1f2937;
}

.nova-reserva-summary-regime {
  display: inline-flex;
  padding: 3px 10px;
  border-radius: 999px;
  background: #dbeafe;
  color: #004790;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.06em;
}

.nova-reserva-summary-observation {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.nova-reserva-summary-observation-label {
  font-size: 13px;
  font-weight: 500;
  color: #374151;
}

.nova-reserva-summary-observation-input {
  width: 100%;
  padding: 10px 12px;
  font-size: 14px;
  font-family: inherit;
  color: #1f2937;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  resize: vertical;
  min-height: 76px;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.nova-reserva-summary-observation-input::placeholder {
  color: #9ca3af;
}

.nova-reserva-summary-observation-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

@media (max-width: 600px) {
  .nova-reserva-card {
    padding: 18px 16px;
  }
}
</style>