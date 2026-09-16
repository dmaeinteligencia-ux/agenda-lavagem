<template>
  <form class="veiculo-form" @submit.prevent>
    <VeiculoIdentificationFields :form="form" :tipos="tipos" :readonly="readonly" />
    <VeiculoDataFields :form="form" :readonly="readonly" />
  </form>
</template>

<script setup lang="ts">
import VeiculoIdentificationFields from './VeiculoIdentificationFields.vue'
import VeiculoDataFields from './VeiculoDataFields.vue'
import type { TipoVeiculo, VeiculoFormData } from '@/utils/veiculos'

interface Props {
  form: VeiculoFormData
  tipos: TipoVeiculo[]
  readonly?: boolean
}

withDefaults(defineProps<Props>(), {
  readonly: false
})
</script>

<style scoped>
.veiculo-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}
</style>
