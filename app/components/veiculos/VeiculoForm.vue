<template>
  <form class="veiculo-form" @submit.prevent>
    <VeiculoIdentificationFields />
    <VeiculoDataFields />
    <VeiculoAcquisitionFields />
  </form>
</template>

<script setup lang="ts">
import VeiculoIdentificationFields from './VeiculoIdentificationFields.vue'
import VeiculoDataFields from './VeiculoDataFields.vue'
import VeiculoAcquisitionFields from './VeiculoAcquisitionFields.vue'
</script>

<style scoped>
.veiculo-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}
</style>