<template>
  <section class="nova-reserva-card" aria-labelledby="nova-reserva-date-title">
    <header class="nova-reserva-card-header">
      <h2 id="nova-reserva-date-title" class="nova-reserva-card-title">
        <span class="nova-reserva-card-step" aria-hidden="true">3</span>
        Data da lavagem
      </h2>
    </header>
    <div class="nova-reserva-date-card-body">
      <NovaReservaDateField
        label="Data da lavagem"
        :model-value="date"
        :min="minDate"
        @update:model-value="$emit('update:date', $event)"
      />
      <div class="nova-reserva-date-regime">
        <span class="nova-reserva-date-regime-label">Regime operacional</span>
        <span class="nova-reserva-regime-badge">{{ regime }}</span>
        <p class="nova-reserva-date-regime-desc">Regime definido para esta data.</p>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import NovaReservaDateField from './NovaReservaDateField.vue'

interface Props {
  date: string
  regime: string
  minDate: string
}

defineProps<Props>()

defineEmits<{
  'update:date': [value: string]
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

.nova-reserva-date-card-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.nova-reserva-date-regime {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding-top: 16px;
  border-top: 1px solid #e5e7eb;
}

.nova-reserva-date-regime-label {
  font-size: 13px;
  font-weight: 500;
  color: #374151;
}

.nova-reserva-regime-badge {
  display: inline-flex;
  align-items: center;
  width: fit-content;
  padding: 4px 12px;
  border-radius: 999px;
  background: #dbeafe;
  color: #004790;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.06em;
}

.nova-reserva-date-regime-desc {
  margin: 0;
  font-size: 12px;
  color: #9ca3af;
}

@media (max-width: 600px) {
  .nova-reserva-card {
    padding: 18px 16px;
  }
}
</style>
