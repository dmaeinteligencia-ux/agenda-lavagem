<template>
  <div class="nova-reserva-vehicle-info">
    <div class="nova-reserva-vehicle-info-main">
      <TruckIcon class="nova-reserva-vehicle-info-icon" aria-hidden="true" />
      <div class="nova-reserva-vehicle-info-identification">
        <span class="nova-reserva-vehicle-info-label">Identificação</span>
        <strong class="nova-reserva-vehicle-info-code">{{ vehicle.identification }}</strong>
      </div>
    </div>
    <dl class="nova-reserva-vehicle-info-details">
      <div class="nova-reserva-vehicle-info-item">
        <dt>Placa</dt>
        <dd>{{ vehicle.plate }}</dd>
      </div>
      <div class="nova-reserva-vehicle-info-item">
        <dt>Tipo</dt>
        <dd>{{ vehicle.type }}</dd>
      </div>
    </dl>
  </div>
</template>

<script setup lang="ts">
import { TruckIcon } from '@heroicons/vue/24/outline'
import type { NovaReservaVehicle } from '@/utils/novaReservaDemo'

interface Props {
  vehicle: NovaReservaVehicle
}

defineProps<Props>()
</script>

<style scoped>
.nova-reserva-vehicle-info {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  background: #f0f9ff;
  border: 1px solid #bfdbfe;
  border-radius: 12px;
  padding: 16px 20px;
}

.nova-reserva-vehicle-info-main {
  display: flex;
  align-items: center;
  gap: 14px;
}

.nova-reserva-vehicle-info-icon {
  width: 40px;
  height: 40px;
  padding: 8px;
  border-radius: 10px;
  background: #dbeafe;
  color: #004790;
  flex-shrink: 0;
}

.nova-reserva-vehicle-info-identification {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.nova-reserva-vehicle-info-label {
  font-size: 12px;
  color: #6b7280;
}

.nova-reserva-vehicle-info-code {
  font-size: 20px;
  font-weight: 700;
  color: #004790;
  letter-spacing: 0.02em;
}

.nova-reserva-vehicle-info-details {
  display: flex;
  gap: 32px;
  margin: 0;
}

.nova-reserva-vehicle-info-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.nova-reserva-vehicle-info-item dt {
  font-size: 12px;
  color: #6b7280;
}

.nova-reserva-vehicle-info-item dd {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #1f2937;
}

@media (max-width: 600px) {
  .nova-reserva-vehicle-info {
    flex-direction: column;
    align-items: flex-start;
  }

  .nova-reserva-vehicle-info-details {
    width: 100%;
    justify-content: space-between;
    gap: 12px;
  }
}
</style>