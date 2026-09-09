<template>
  <div class="jornada-lavador-summary">
    <div class="summary-grid">
      <div class="summary-card">
        <div class="card-icon">
          <CalendarDaysIcon class="card-icon-inner" />
        </div>
        <div class="card-content">
          <span class="card-label">Regimes Cadastrados</span>
          <span class="card-value">{{ summary.totalRegimes }}</span>
        </div>
      </div>
      <div class="summary-card">
        <div class="card-icon" :style="{ background: '#dbeafe', color: '#1e40af' }">
          <ClockIcon class="card-icon-inner" />
        </div>
        <div class="card-content">
          <span class="card-label">Capacidade Normal</span>
          <span class="card-value">{{ summary.normalHours }}h</span>
        </div>
      </div>
      <div class="summary-card">
        <div class="card-icon" :style="{ background: '#fed7aa', color: '#9a3412' }">
          <MoonIcon class="card-icon-inner" />
        </div>
        <div class="card-content">
          <span class="card-label">Capacidade Plantão</span>
          <span class="card-value">{{ summary.plantaoHours }}h</span>
        </div>
      </div>
      <div class="summary-card">
        <div class="card-icon" :style="{ background: '#dcfce7', color: '#166534' }">
          <CalculatorIcon class="card-icon-inner" />
        </div>
        <div class="card-content">
          <span class="card-label">Capacidade Média</span>
          <span class="card-value">{{ summary.averageCapacity }}h</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { CalendarDaysIcon, ClockIcon, MoonIcon, CalculatorIcon } from '@heroicons/vue/24/outline'
import type { JornadaLavadorSummary } from '@/utils/jornadaLavadorMock'

defineProps<{
  summary: JornadaLavadorSummary
}>()
</script>

<style scoped>
.jornada-lavador-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  margin-top: 16px;
}

.summary-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  border: 1px solid #e5e7eb;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: transform 0.15s, box-shadow 0.15s;
}

.summary-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
}

.card-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  font-size: 18px;
}

.card-icon-inner {
  font-size: 20px;
}

.card-content {
  display: flex;
  flex-direction: column;
}

.card-label {
  font-size: 13px;
  color: #6b7280;
  font-weight: 500;
}

.card-value {
  font-size: 18px;
  font-weight: 700;
  color: #111827;
  margin-top: 4px;
}

@media (max-width: 640px) {
  .jornada-lavador-summary {
    grid-template-columns: 1fr;
  }
}
</style>