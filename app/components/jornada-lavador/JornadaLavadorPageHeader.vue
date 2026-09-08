<template>
  <header class="jornada-lavador-page-header">
    <div class="jornada-lavador-page-header-text">
      <h1 class="jornada-lavador-page-header-title">Jornada do Lavador</h1>
      <p class="jornada-lavador-page-header-subtitle">Configure a capacidade de funcionamento do lavador por regime.</p>
    </div>
    <button type="button" class="jornada-lavador-new-jornada-btn" aria-label="Nova Jornada">
      <PlusIcon class="jornada-lavador-new-jornada-btn-icon" aria-hidden="true" />
      Nova Jornada
    </button>
  </header>
</template>

<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.jornada-lavador-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.jornada-lavador-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.jornada-lavador-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.jornada-lavador-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.jornada-lavador-new-jornada-btn {
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
  transition: background-color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.jornada-lavador-new-jornada-btn:hover {
  background-color: #003570;
}

.jornada-lavador-new-jornada-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.jornada-lavador-new-jornada-btn-icon {
  width: 18px;
  height: 18px;
}

@media (max-width: 600px) {
  .jornada-lavador-page-header {
    align-items: flex-start;
  }

  .jornada-lavador-page-header-title {
    font-size: 20px;
  }

  .jornada-lavador-page-header-subtitle {
    font-size: 13px;
  }
}
</style>