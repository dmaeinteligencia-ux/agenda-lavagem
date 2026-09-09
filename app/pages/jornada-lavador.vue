<template>
  <div class="jornada-lavador-page">
    <JornadaLavadorPageHeader @new-jornada="handleNewJornada" />
    <JornadaLavadorSummary :summary="summary" />
    <JornadaLavadorTable :jornadas="jornadas" @edit="handleEditJornada" />
    <JornadaLavadorModal
      v-model:visible="showModal"
      :mode="modalMode"
      :jornadaEdicao="jornadaEdicao"
      @save="handleSaveJornada"
      @cancel="handleCancel"
    />
    <Toast />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useToast } from 'primevue/usetoast'
import JornadaLavadorPageHeader from '@/components/jornada-lavador/JornadaLavadorPageHeader.vue'
import JornadaLavadorSummary from '@/components/jornada-lavador/JornadaLavadorSummary.vue'
import JornadaLavadorTable from '@/components/jornada-lavador/JornadaLavadorTable.vue'
import JornadaLavadorModal from '@/components/jornada-lavador/JornadaLavadorModal.vue'
import { jornadasLavadorMock, jornadaLavadorSummary } from '@/utils/jornadaLavadorMock'
import type { JornadaLavador } from '@/utils/jornadaLavadorMock'

definePageMeta({
  layout: 'default'
})

const toast = useToast()
const showModal = ref(false)
const modalMode = ref<'create' | 'edit'>('create')
const jornadaEdicao = ref<JornadaLavador | null>(null)
const jornadas = ref<JornadaLavador[]>([])
const summary = ref(jornadaLavadorSummary())

onMounted(() => {
  jornadas.value = [...jornadasLavadorMock]
})

const handleNewJornada = () => {
  modalMode.value = 'create'
  jornadaEdicao.value = null
  showModal.value = true
}

const handleEditJornada = (jornada: JornadaLavador) => {
  modalMode.value = 'edit'
  jornadaEdicao.value = { ...jornada }
  showModal.value = true
}

const handleSaveJornada = (data: JornadaLavador) => {
  if (modalMode.value === 'edit' && jornadaEdicao.value) {
    const index = jornadas.value.findIndex(j => j.id === data.id)
    if (index !== -1) {
      jornadas.value[index] = { ...data }
    }
    toast.add({
      severity: 'success',
      summary: 'Sucesso',
      detail: 'Jornada atualizada com sucesso.'
    })
  } else {
    const newId = String(jornadas.value.length + 1)
    jornadas.value.push({ ...data, id: newId })
    toast.add({
      severity: 'success',
      summary: 'Sucesso',
      detail: 'Jornada cadastrada com sucesso.'
    })
  }
  summary.value = jornadaLavadorSummary()
}

const handleCancel = () => {
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