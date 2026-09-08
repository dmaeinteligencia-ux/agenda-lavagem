<template>
  <div class="nova-reserva-page">
    <NovaReservaPageHeader />
    <NovaReservaSteps :steps="steps" :current="currentStep" />

    <div class="nova-reserva-grid">
      <div class="nova-reserva-column">
        <NovaReservaVehicleCard :vehicle="demo.vehicle" />
        <NovaReservaDateCard :date="demo.date" :regime="demo.regime" />
      </div>
      <div class="nova-reserva-column">
        <NovaReservaAvailabilityCard
          :capacity="demo.capacity"
          :utilization="demo.utilization"
          :utilization-percent="demo.utilizationPercent"
          :estimated-time="demo.estimatedTime"
          :availability="demo.availability"
        />
        <NovaReservaSummaryCard
          :vehicle="demo.vehicle"
          :date="demo.date"
          :regime="demo.regime"
          :estimated-time="demo.estimatedTime"
        />
      </div>
    </div>

    <NovaReservaActions />
  </div>
</template>

<script setup lang="ts">
import NovaReservaPageHeader from '@/components/nova-reserva/NovaReservaPageHeader.vue'
import NovaReservaSteps from '@/components/nova-reserva/NovaReservaSteps.vue'
import NovaReservaVehicleCard from '@/components/nova-reserva/NovaReservaVehicleCard.vue'
import NovaReservaDateCard from '@/components/nova-reserva/NovaReservaDateCard.vue'
import NovaReservaAvailabilityCard from '@/components/nova-reserva/NovaReservaAvailabilityCard.vue'
import NovaReservaSummaryCard from '@/components/nova-reserva/NovaReservaSummaryCard.vue'
import NovaReservaActions from '@/components/nova-reserva/NovaReservaActions.vue'
import { demoReservation } from '@/utils/novaReservaDemo'

const demo = demoReservation

const steps = [
  { label: 'Veículo' },
  { label: 'Data' },
  { label: 'Disponibilidade' },
  { label: 'Resumo' }
]

const currentStep = 0

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.nova-reserva-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.nova-reserva-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
  align-items: start;
}

.nova-reserva-column {
  display: flex;
  flex-direction: column;
  gap: 24px;
  min-width: 0;
}

@media (max-width: 1024px) {
  .nova-reserva-grid {
    grid-template-columns: 1fr;
  }

  .nova-reserva-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .nova-reserva-page {
    padding: 16px 12px;
    gap: 16px;
  }

  .nova-reserva-grid {
    gap: 16px;
  }

  .nova-reserva-column {
    gap: 16px;
  }
}
</style>