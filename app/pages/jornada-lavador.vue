<template>
  <div class="jornada-lavador-page">
    <JornadaLavadorPageHeader />
    <JornadaLavadorSummary :summary="summary" />
    <JornadaLavadorTable />
    <JornadaLavadorModal v-if="showModal" :mode="modalMode" :jornadaEdicao="jornadaEdicao" />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import JornadaLavadorPageHeader from '@/components/jornada-lavador/JornadaLavadorPageHeader.vue'
import JornadaLavadorSummary from '@/components/jornada-lavador/JornadaLavadorSummary.vue'
import JornadaLavadorTable from '@/components/jornada-lavador/JornadaLavadorTable.vue'
import JornadaLavadorModal from '@/components/jornada-lavador/JornadaLavadorModal.vue'
import { jornadasLavadorMock, jornadaLavadorSummary } from '@/utils/jornadaLavadorMock'

const summary = jornadaLavadorSummary
const showModal = ref(false)
const modalMode = ref<'create' | 'edit'>('create')
const jornadaEdicao = ref(null)

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.jornada-lavador-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

@media (max-width: 1024px) {
  .jornada-lavador-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .jornada-lavador-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>