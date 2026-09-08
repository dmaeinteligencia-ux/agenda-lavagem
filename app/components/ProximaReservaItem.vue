<template>
  <div class="proxima-reserva-item">
    <div class="proxima-reserva-date">
      <span class="proxima-reserva-day">{{ dayLabel }}</span>
      <span class="proxima-reserva-num">{{ dateNum }}</span>
    </div>
    <div class="proxima-reserva-info">
      <div class="proxima-reserva-top">
        <span class="proxima-reserva-veiculo">{{ veiculo }}</span>
        <StatusBadge :status="status" />
      </div>
      <div class="proxima-reserva-grid">
        <div class="proxima-reserva-field">
          <span class="field-label">Placa</span>
          <span class="field-value">{{ placa }}</span>
        </div>
        <div class="proxima-reserva-field">
          <span class="field-label">Tipo</span>
          <span class="field-value">{{ tipo }}</span>
        </div>
        <div class="proxima-reserva-field">
          <span class="field-label">Regime</span>
          <span class="field-value">{{ regime }}</span>
        </div>
        <div class="proxima-reserva-field">
          <span class="field-label">Horário</span>
          <span class="field-value">{{ horario }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import StatusBadge from './StatusBadge.vue'

interface Props {
  veiculo: string
  placa: string
  tipo: string
  regime: string
  horario: string
  status: string
  data: string
}

const props = defineProps<Props>()

const parsedDate = computed(() => {
  const d = new Date(props.data + 'T00:00:00')
  return isNaN(d.getTime()) ? null : d
})

const dayLabel = computed(() => {
  if (!parsedDate.value) return props.data
  return parsedDate.value.toLocaleDateString('pt-BR', { weekday: 'short' })
})

const dateNum = computed(() => {
  if (!parsedDate.value) return props.data
  return parsedDate.value.getDate().toString()
})
</script>

<style scoped>
.proxima-reserva-item {
  display: flex;
  gap: 14px;
  padding: 12px 0;
  border-bottom: 1px solid #f1f5f9;
}

.proxima-reserva-item:last-child {
  border-bottom: none;
}

.proxima-reserva-date {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-width: 48px;
  padding: 8px 4px;
  background: #f8fafc;
  border-radius: 8px;
}

.proxima-reserva-day {
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #94a3b8;
}

.proxima-reserva-num {
  font-size: 16px;
  font-weight: 700;
  color: #1e293b;
}

.proxima-reserva-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 0;
}

.proxima-reserva-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.proxima-reserva-veiculo {
  font-weight: 600;
  color: #111827;
  font-size: 14px;
}

.proxima-reserva-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 4px 12px;
}

.proxima-reserva-field {
  display: flex;
  flex-direction: column;
  line-height: 1.3;
}

.field-label {
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  color: #94a3b8;
}

.field-value {
  font-size: 12px;
  font-weight: 500;
  color: #374151;
}
</style>