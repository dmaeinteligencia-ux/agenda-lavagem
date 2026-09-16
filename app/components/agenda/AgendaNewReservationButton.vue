<template>
  <NuxtLink to="/nova-reserva" class="agenda-new-reservation-btn">
    <PlusIcon aria-hidden="true" />
    Nova Reserva
  </NuxtLink>
</template>

<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.agenda-new-reservation-btn {
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

.agenda-new-reservation-btn:hover {
  background-color: #003570;
}

.agenda-new-reservation-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.agenda-new-reservation-btn:active {
  transform: translateY(1px);
}

.agenda-new-reservation-btn svg {
  width: 18px;
  height: 18px;
}
</style>
