<template>
  <section class="nova-reserva-card" aria-labelledby="nova-reserva-vehicle-title">
    <header class="nova-reserva-card-header">
      <h2 id="nova-reserva-vehicle-title" class="nova-reserva-card-title">
        <span class="nova-reserva-card-step" aria-hidden="true">1</span>
        Veículo
      </h2>
      <p class="nova-reserva-card-subtitle">Pesquise o veículo pela placa.</p>
    </header>
    <div class="nova-reserva-card-body nova-reserva-vehicle-card-body">
      <NovaReservaVehicleSearch />
      <NovaReservaVehicleInfo :vehicle="vehicle" />
    </div>
  </section>
</template>

<script setup lang="ts">
import NovaReservaVehicleSearch from './NovaReservaVehicleSearch.vue'
import NovaReservaVehicleInfo from './NovaReservaVehicleInfo.vue'
import type { NovaReservaVehicle } from '@/utils/novaReservaDemo'

interface Props {
  vehicle: NovaReservaVehicle
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

.nova-reserva-card-subtitle {
  margin: 0;
  font-size: 13px;
  color: #6b7280;
}

.nova-reserva-card-body {
  display: flex;
  flex-direction: column;
}

.nova-reserva-vehicle-card-body {
  gap: 20px;
}

@media (max-width: 600px) {
  .nova-reserva-card {
    padding: 18px 16px;
  }
}
</style>