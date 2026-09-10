<template>
  <div class="jornada-lavador-page">
    <JornadaLavadorPageHeader @new-jornada="openCreate" />
    <JornadaLavadorSummary :summary="summary" />
    <JornadaLavadorTable
      :jornadas="jornadas"
      @edit="openEdit"
      @new-jornada="openCreate"
    />

    <JornadaLavadorModal
      v-if="showModal"
      :mode="modalMode"
      :jornada="jornadaEdicao"
      @close="closeModal"
      @save="handleSave"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import JornadaLavadorPageHeader from '@/components/jornada-lavador/JornadaLavadorPageHeader.vue'
import JornadaLavadorSummary from '@/components/jornada-lavador/JornadaLavadorSummary.vue'
import JornadaLavadorTable from '@/components/jornada-lavador/JornadaLavadorTable.vue'
import JornadaLavadorModal from '@/components/jornada-lavador/JornadaLavadorModal.vue'
import { jornadasLavadorMock, jornadaLavadorSummary, diasPorRegime } from '@/utils/jornadaLavadorMock'
import type { JornadaLavadorMock, JornadaLavadorFormData } from '@/utils/jornadaLavadorMock'

definePageMeta({
  layout: 'default'
})

const summary = jornadaLavadorSummary
const jornadas = ref<JornadaLavadorMock[]>([...jornadasLavadorMock])
const showModal = ref(false)
const modalMode = ref<'create' | 'edit'>('create')
const jornadaEdicao = ref<JornadaLavadorMock | null>(null)

const openCreate = () => {
  modalMode.value = 'create'
  jornadaEdicao.value = null
  showModal.value = true
}

const openEdit = (jornada: JornadaLavadorMock) => {
  modalMode.value = 'edit'
  jornadaEdicao.value = { ...jornada }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const handleSave = (data: JornadaLavadorFormData) => {
  if (modalMode.value === 'edit' && jornadaEdicao.value) {
    const index = jornadas.value.findIndex((j) => j.id === jornadaEdicao.value?.id)
    if (index !== -1) {
      jornadas.value[index] = {
        ...jornadas.value[index],
        regime: data.regime,
        dias: diasPorRegime(data.regime),
        horas: data.horas,
        disponivel_agendamento: data.disponivel_agendamento
      }
    }
  } else {
    jornadas.value.push({
      id: String(Date.now()),
      regime: data.regime,
      dias: diasPorRegime(data.regime),
      horas: data.horas,
      disponivel_agendamento: data.disponivel_agendamento
    })
  }
  showModal.value = false
}
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
