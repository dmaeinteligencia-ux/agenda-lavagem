<template>
  <div class="agenda-date-navigator">
    <button class="nav-btn" aria-label="Data anterior">
      <ChevronLeftIcon aria-hidden="true" />
    </button>
    <span class="nav-date">28 de agosto de 2026</span>
    <button class="nav-btn" aria-label="Data seguinte">
      <ChevronRightIcon aria-hidden="true" />
    </button>
    <button class="nav-btn nav-btn--hoje">Hoje</button>
  </div>
</template>

<script setup lang="ts">
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.agenda-date-navigator {
  display: flex;
  align-items: center;
  gap: 8px;
}

.nav-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  cursor: pointer;
  color: #6b7280;
  transition: all 0.2s;
}

.nav-btn:hover {
  border-color: #004790;
  color: #004790;
}

.nav-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}

.nav-btn svg {
  width: 18px;
  height: 18px;
}

.nav-date {
  font-size: 14px;
  font-weight: 600;
  color: #1f2937;
  padding: 0 8px;
  white-space: nowrap;
}

.nav-btn--hoje {
  width: auto;
  padding: 0 12px;
  font-size: 13px;
  font-weight: 500;
  background: #004790;
  color: #fff;
  border-color: #004790;
}

.nav-btn--hoje:hover {
  background: #003570;
  color: #fff;
}
</style>