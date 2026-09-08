<template>
  <div class="veiculo-form-section">
    <h4 class="veiculo-form-section-title">Aquisição</h4>
    <div class="veiculo-form-grid">
      <BaseInput label="Data de aquisição" placeholder="Ex: 15/03/2023" />
    </div>
  </div>
</template>

<script setup lang="ts">
import BaseInput from '@/components/BaseInput.vue'
</script>

<style scoped>
.veiculo-form-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.veiculo-form-section-title {
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #6b7280;
  margin: 0;
  padding-bottom: 8px;
  border-bottom: 1px solid #e5e7eb;
}

.veiculo-form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

@media (max-width: 600px) {
  .veiculo-form-grid {
    grid-template-columns: 1fr;
  }
}
</style>