<template>
  <section class="nova-reserva-card" aria-labelledby="nova-reserva-availability-title">
    <header class="nova-reserva-card-header">
      <h2 id="nova-reserva-availability-title" class="nova-reserva-card-title">
        <span class="nova-reserva-card-step" aria-hidden="true">4</span>
        Disponibilidade
      </h2>
    </header>
    <div class="nova-reserva-availability-body">
      <div class="nova-reserva-availability-indicators">
        <div class="nova-reserva-availability-indicator">
          <span class="nova-reserva-availability-indicator-label">Capacidade</span>
          <strong class="nova-reserva-availability-indicator-value">{{ capacity.total }}</strong>
        </div>
        <div class="nova-reserva-availability-indicator">
          <span class="nova-reserva-availability-indicator-label">Utilizado</span>
          <strong class="nova-reserva-availability-indicator-value">{{ capacity.used }}</strong>
        </div>
        <div class="nova-reserva-availability-indicator nova-reserva-availability-indicator--available">
          <span class="nova-reserva-availability-indicator-label">Disponível</span>
          <strong class="nova-reserva-availability-indicator-value">{{ capacity.available }}</strong>
        </div>
      </div>

      <div class="nova-reserva-availability-usage">
        <div class="nova-reserva-availability-usage-meta">
          <span class="nova-reserva-availability-usage-label">Utilização do dia</span>
          <span class="nova-reserva-availability-usage-value">{{ utilization }}</span>
        </div>
        <div
          class="nova-reserva-availability-usage-track"
          role="progressbar"
          :aria-valuenow="utilizationPercent"
          aria-valuemin="0"
          aria-valuemax="100"
          :aria-label="utilization"
        >
          <div
            class="nova-reserva-availability-usage-bar"
            :style="{ width: `${utilizationPercent}%` }"
          />
        </div>
      </div>

      <div class="nova-reserva-availability-vehicle-time">
        <div class="nova-reserva-availability-vehicle-time-text">
          <span class="nova-reserva-availability-vehicle-time-label">Tempo estimado para este veículo</span>
          <p class="nova-reserva-availability-vehicle-time-desc">Calculado conforme o tipo de veículo.</p>
        </div>
        <strong class="nova-reserva-availability-vehicle-time-value">{{ estimatedTime }}</strong>
      </div>

      <NovaReservaAvailabilityStatus :status="availability" />
    </div>
  </section>
</template>

<script setup lang="ts">
import NovaReservaAvailabilityStatus from './NovaReservaAvailabilityStatus.vue'
import type { NovaReservaCapacity } from '@/utils/reservas'

interface Props {
  capacity: NovaReservaCapacity
  utilization: string
  utilizationPercent: number
  estimatedTime: string
  availability: 'Disponível' | 'Indisponível'
}

defineProps<Props>()
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

.nova-reserva-availability-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.nova-reserva-availability-indicators {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.nova-reserva-availability-indicator {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 14px;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
}

.nova-reserva-availability-indicator--available {
  background: #f0f9ff;
  border-color: #bfdbfe;
}

.nova-reserva-availability-indicator-label {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #6b7280;
}

.nova-reserva-availability-indicator-value {
  font-size: 20px;
  font-weight: 700;
  color: #1f2937;
}

.nova-reserva-availability-indicator--available .nova-reserva-availability-indicator-value {
  color: #0369a1;
}

.nova-reserva-availability-usage {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.nova-reserva-availability-usage-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.nova-reserva-availability-usage-label {
  font-size: 13px;
  font-weight: 500;
  color: #374151;
}

.nova-reserva-availability-usage-value {
  font-size: 13px;
  font-weight: 700;
  color: #004790;
}

.nova-reserva-availability-usage-track {
  height: 8px;
  background: #e5e7eb;
  border-radius: 999px;
  overflow: hidden;
}

.nova-reserva-availability-usage-bar {
  height: 100%;
  border-radius: 999px;
  background: linear-gradient(90deg, #004790, #2f7ac0);
  transition: width 0.3s ease;
}

.nova-reserva-availability-vehicle-time {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  padding: 14px;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  background: #f9fafb;
}

.nova-reserva-availability-vehicle-time-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.nova-reserva-availability-vehicle-time-label {
  font-size: 13px;
  font-weight: 500;
  color: #374151;
}

.nova-reserva-availability-vehicle-time-desc {
  margin: 0;
  font-size: 12px;
  color: #9ca3af;
}

.nova-reserva-availability-vehicle-time-value {
  font-size: 20px;
  font-weight: 700;
  color: #004790;
  white-space: nowrap;
}

@media (max-width: 600px) {
  .nova-reserva-card {
    padding: 18px 16px;
  }

  .nova-reserva-availability-indicators {
    grid-template-columns: 1fr;
  }

  .nova-reserva-availability-indicator {
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
    padding: 12px 14px;
  }
}
</style>