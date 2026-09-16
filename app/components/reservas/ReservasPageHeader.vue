<template>
  <header class="reservas-page-header">
    <div class="reservas-page-header-text">
      <h1 class="reservas-page-header-title">Reservas</h1>
      <p class="reservas-page-header-subtitle">Consulte e acompanhe as reservas de lavagem da frota.</p>
    </div>
    <NuxtLink to="/nova-reserva" class="reservas-new-reservation-btn" aria-label="Nova Reserva">
      <PlusIcon class="reservas-new-reservation-btn-icon" aria-hidden="true" />
      Nova Reserva
    </NuxtLink>
  </header>
</template>

<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.reservas-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.reservas-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.reservas-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.reservas-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.reservas-new-reservation-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  text-decoration: none;
  transition: background-color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.reservas-new-reservation-btn:hover {
  background-color: #003570;
}

.reservas-new-reservation-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.reservas-new-reservation-btn-icon {
  width: 18px;
  height: 18px;
}

@media (max-width: 600px) {
  .reservas-page-header {
    align-items: flex-start;
  }

  .reservas-page-header-title {
    font-size: 20px;
  }

  .reservas-page-header-subtitle {
    font-size: 13px;
  }
}
</style>