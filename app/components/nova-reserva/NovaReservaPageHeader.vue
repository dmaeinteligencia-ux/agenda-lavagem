<template>
  <header class="nova-reserva-page-header">
    <div class="nova-reserva-page-header-text">
      <h1 class="nova-reserva-page-header-title">Nova Reserva</h1>
      <p class="nova-reserva-page-header-subtitle">Agende uma lavagem para um veículo da frota.</p>
    </div>
    <span class="nova-reserva-badge">
      <CalendarDaysIcon class="nova-reserva-badge-icon" aria-hidden="true" />
      Nova reserva
    </span>
  </header>
</template>

<script setup lang="ts">
import { CalendarDaysIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.nova-reserva-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.nova-reserva-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.nova-reserva-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.nova-reserva-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.nova-reserva-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 999px;
  background: #dbeafe;
  color: #004790;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.nova-reserva-badge-icon {
  width: 16px;
  height: 16px;
}

@media (max-width: 600px) {
  .nova-reserva-page-header {
    align-items: flex-start;
  }

  .nova-reserva-page-header-title {
    font-size: 20px;
  }

  .nova-reserva-page-header-subtitle {
    font-size: 13px;
  }
}
</style>