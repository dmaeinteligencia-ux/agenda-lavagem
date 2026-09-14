<template>
  <div class="solicitantes-page">
    <SolicitantesPageHeader @new-solicitante="openCreate" />
    <SolicitantesSummary :summary="{ total: total }" />
    <SolicitantesSearch v-model="searchQuery" />

    <div v-if="loading" class="solicitantes-loading">
      <span class="solicitantes-spinner" aria-hidden="true" />
      <span>Carregando solicitantes...</span>
    </div>

    <div v-else-if="error" class="solicitantes-erro" role="alert">
      <p class="solicitantes-erro-mensagem">{{ error }}</p>
      <button type="button" class="solicitantes-erro-btn" @click="fetchSolicitantes">
        Tentar novamente
      </button>
    </div>

    <SolicitantesTable
      v-else
      :solicitantes="filteredSolicitantes"
      :has-solicitantes="solicitantes.length > 0"
      @edit="openEdit"
      @new-solicitante="openCreate"
    />

    <SolicitanteModal
      v-if="showModal"
      :mode="modalMode"
      :solicitante="solicitanteEdicao"
      :loading="saving"
      :error="saveError"
      @close="closeModal"
      @save="handleSave"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import SolicitantesPageHeader from '@/components/solicitantes/SolicitantesPageHeader.vue'
import SolicitantesSummary from '@/components/solicitantes/SolicitantesSummary.vue'
import SolicitantesSearch from '@/components/solicitantes/SolicitantesSearch.vue'
import SolicitantesTable from '@/components/solicitantes/SolicitantesTable.vue'
import SolicitanteModal from '@/components/solicitantes/SolicitanteModal.vue'
import { useSolicitantes } from '@/composables/useSolicitantes'
import type { SolicitanteMock, SolicitanteFormData } from '@/utils/solicitantesMock'

definePageMeta({
  layout: 'default'
})

const {
  solicitantes,
  loading,
  error,
  fetchSolicitantes,
  createSolicitante,
  updateSolicitante
} = useSolicitantes()

const searchQuery = ref('')
const showModal = ref(false)
const modalMode = ref<'create' | 'edit'>('create')
const solicitanteEdicao = ref<SolicitanteMock | null>(null)
const saving = ref(false)
const saveError = ref<string | null>(null)

const total = computed(() => String(solicitantes.value.length))

const filteredSolicitantes = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  if (!query) {
    return solicitantes.value
  }
  return solicitantes.value.filter(
    (solicitante) =>
      solicitante.matricula.toLowerCase().includes(query) ||
      solicitante.nome.toLowerCase().includes(query) ||
      solicitante.telefone.toLowerCase().includes(query)
  )
})

const sortByName = () => {
  solicitantes.value = [...solicitantes.value].sort((a, b) =>
    a.nome.localeCompare(b.nome, 'pt-BR')
  )
}

const openCreate = () => {
  modalMode.value = 'create'
  solicitanteEdicao.value = null
  saveError.value = null
  showModal.value = true
}

const openEdit = (solicitante: SolicitanteMock) => {
  modalMode.value = 'edit'
  solicitanteEdicao.value = { ...solicitante }
  saveError.value = null
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const mapSaveError = (err: { code?: string } | null): string => {
  if (err?.code === '23505') {
    return 'Já existe um solicitante cadastrado com esta matrícula.'
  }
  return 'Não foi possível salvar o solicitante. Tente novamente.'
}

const handleSave = async (data: SolicitanteFormData) => {
  saving.value = true
  saveError.value = null

  try {
    if (modalMode.value === 'edit' && solicitanteEdicao.value) {
      const { data: atualizado, error: err } = await updateSolicitante(
        solicitanteEdicao.value.id,
        data
      )
      if (err) {
        saveError.value = mapSaveError(err)
        return
      }
      if (atualizado) {
        const index = solicitantes.value.findIndex((s) => s.id === atualizado.id)
        if (index !== -1) {
          solicitantes.value[index] = atualizado
        }
      }
      sortByName()
    } else {
      const { data: criado, error: err } = await createSolicitante(data)
      if (err) {
        saveError.value = mapSaveError(err)
        return
      }
      if (criado) {
        solicitantes.value.push(criado)
      }
      sortByName()
    }

    showModal.value = false
  } catch (err) {
    saveError.value = 'Não foi possível salvar o solicitante. Tente novamente.'
    console.error('Erro ao salvar solicitante:', err)
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchSolicitantes()
})
</script>

<style scoped>
.solicitantes-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.solicitantes-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  color: #6b7280;
  font-size: 14px;
}

.solicitantes-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: solicitantes-spin 0.8s linear infinite;
}

@keyframes solicitantes-spin {
  to {
    transform: rotate(360deg);
  }
}

.solicitantes-erro {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  text-align: center;
}

.solicitantes-erro-mensagem {
  margin: 0;
  font-size: 14px;
  color: #4b5563;
}

.solicitantes-erro-btn {
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
  transition: background-color 0.2s;
}

.solicitantes-erro-btn:hover {
  background: #e8f0fe;
}

@media (max-width: 1024px) {
  .solicitantes-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .solicitantes-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>
