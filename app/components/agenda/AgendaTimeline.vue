<template>
  <div class="agenda-timeline">
    <div class="agenda-timeline-header">
      <h3 class="agenda-timeline-title">Agenda do Dia</h3>
      <span class="agenda-timeline-regime">PLANTÃO</span>
    </div>
    <div class="agenda-timeline-body">
      <div
        v-for="slot in timeline"
        :key="slot.time"
        class="agenda-timeline-row"
      >
        <AgendaTimeSlot :time="slot.time" />
        <div class="agenda-timeline-content">
          <template v-if="slot.type === 'reservation'">
            <AgendaReservationBlock
              :vehicle="slot.reservation.vehicle"
              :plate="slot.reservation.plate"
              :type="slot.reservation.type"
              :start="slot.reservation.start"
              :end="slot.reservation.end"
              :status="slot.reservation.status"
            />
          </template>
          <template v-else-if="slot.type === 'available'">
            <AgendaAvailableSlot :time="slot.time" />
          </template>
          <template v-else>
            <div class="agenda-timeline-empty"></div>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import AgendaTimeSlot from './AgendaTimeSlot.vue'
import AgendaReservationBlock from './AgendaReservationBlock.vue'
import AgendaAvailableSlot from './AgendaAvailableSlot.vue'

const reservations = [
  { vehicle: 'A11-1234', plate: 'ABC-1A23', type: 'Caminhão', start: '08:00', end: '09:30', status: 'RESERVADA' },
  { vehicle: 'B07-5678', plate: 'DEF-4B56', type: 'Carro', start: '09:30', end: '10:15', status: 'EM_LAVAGEM' },
  { vehicle: 'C02-9101', plate: 'GHI-7C89', type: 'Ônibus', start: '10:30', end: '12:30', status: 'RESERVADA' }
]

const times = ['08:00', '09:00', '09:30', '10:15', '10:30', '12:30', '13:00']

const timeline = times.map((time, idx) => {
  const reservation = reservations.find(r => r.start === time)
  if (reservation) {
    return { time, type: 'reservation' as const, reservation }
  }
  const nextRes = reservations.find(r => r.start > time)
  const prevRes = reservations.find(r => r.end <= time)
  const isAvailableGap = !reservation && prevRes && nextRes
  return {
    time,
    type: (isAvailableGap ? 'available' : 'empty') as 'available' | 'empty',
    reservation: null
  }
})
</script>

<style scoped>
.agenda-timeline {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.agenda-timeline-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.agenda-timeline-title {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.agenda-timeline-regime {
  font-size: 12px;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 999px;
  background: #dbeafe;
  color: #004790;
}

.agenda-timeline-body {
  display: flex;
  flex-direction: column;
  position: relative;
}

.agenda-timeline-row {
  display: flex;
  align-items: stretch;
  min-height: 48px;
  position: relative;
}

.agenda-timeline-row:not(:last-child)::before {
  content: '';
  position: absolute;
  left: 70px;
  top: 0;
  bottom: -1px;
  width: 1px;
  background: #e5e7eb;
}

.agenda-timeline-row::after {
  content: '';
  position: absolute;
  left: 60px;
  top: 50%;
  width: 20px;
  height: 1px;
  background: #e5e7eb;
}

.agenda-timeline-content {
  flex: 1;
  padding: 6px 0 6px 16px;
  display: flex;
  align-items: center;
}

.agenda-timeline-empty {
  width: 100%;
  min-height: 24px;
}
</style>