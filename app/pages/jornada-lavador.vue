<template>
  <div class="jornada-lavador-page">
    <JornadaLavadorPageHeader />
    <JornadaLavadorSummary :summary="summary" />

    <div v-if="loading" class="jornada-lavador-state">
      <span class="jornada-lavador-spinner" aria-hidden="true" />
      <span>Carregando jornadas...</span>
    </div>

    <div v-else-if="error" class="jornada-lavador-state jornada-lavador-state--erro" role="alert">
      <p class="jornada-lavador-state-message">{{ error }}</p>
      <button type="button" class="jornada-lavador-retry" @click="carregar">Tentar novamente</button>
    </div>

    <JornadaLavadorTable
      v-else
      :jornadas="jornadas"
      @edit="openEdit"
    />

    <JornadaLavadorModal
      v-if="showModal && jornadaEdicao"
      :jornada="jornadaEdicao"
      :loading="salvando"
      :error="modalError"
      @close="closeModal"
      @save="handleSave"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import JornadaLavadorPageHeader from '@/components/jornada-lavador/JornadaLavadorPageHeader.vue'
import JornadaLavadorSummary from '@/components/jornada-lavador/JornadaLavadorSummary.vue'
import JornadaLavadorTable from '@/components/jornada-lavador/JornadaLavadorTable.vue'
import JornadaLavadorModal from '@/components/jornada-lavador/JornadaLavadorModal.vue'
import { useJornadaLavador } from '@/composables/useJornadaLavador'
import {
  resumoJornada,
  type JornadaLavador,
  type JornadaLavadorFormData
} from '@/utils/jornadaLavador'

definePageMeta({
  layout: 'default'
})

const {
  jornadas,
  loading,
  error,
  salvandoId,
  carregar,
  atualizarJornada
} = useJornadaLavador()

const showModal = ref(false)
const jornadaEdicao = ref<JornadaLavador | null>(null)
const modalError = ref<string | null>(null)

const summary = computed(() => resumoJornada(jornadas.value))
const salvando = computed(() => salvandoId.value !== null)

const openEdit = (jornada: JornadaLavador) => {
  jornadaEdicao.value = { ...jornada }
  modalError.value = null
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  modalError.value = null
}

const handleSave = async (data: JornadaLavadorFormData) => {
  if (!jornadaEdicao.value) {
    return
  }

  modalError.value = null
  const resultado = await atualizarJornada(jornadaEdicao.value.id, data)

  if (!resultado.success) {
    modalError.value = resultado.error
    return
  }

  showModal.value = false
}

onMounted(carregar)
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

.jornada-lavador-state {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 12px;
  padding: 60px 24px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  color: #6b7280;
  font-size: 14px;
  text-align: center;
}

.jornada-lavador-state--erro {
  color: #4b5563;
}

.jornada-lavador-state-message {
  margin: 0;
}

.jornada-lavador-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: jornada-lavador-spin 0.8s linear infinite;
}

@keyframes jornada-lavador-spin {
  to {
    transform: rotate(360deg);
  }
}

.jornada-lavador-retry {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #004790;
  background: #fff;
  border: 1px solid #004790;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
}

.jornada-lavador-retry:hover {
  background: #e8f0fe;
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
