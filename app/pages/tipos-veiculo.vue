<template>
  <div class="tipos-veiculo-page">
    <TiposVeiculoPageHeader @new-tipo="abrirCriacao" />
    <TiposVeiculoSummary :summary="summary" />
    <TiposVeiculoSearch v-model="busca" />

    <div
      v-if="feedback"
      class="tipos-veiculo-feedback"
      :class="`tipos-veiculo-feedback--${feedback.type}`"
      role="status"
    >
      <span>{{ feedback.message }}</span>
      <button type="button" class="tipos-veiculo-feedback-close" aria-label="Fechar" @click="feedback = null">
        <XMarkIcon aria-hidden="true" />
      </button>
    </div>

    <div v-if="loading" class="tipos-veiculo-state">
      <span class="tipos-veiculo-spinner" aria-hidden="true" />
      <span>Carregando tipos de veículo...</span>
    </div>

    <div v-else-if="error" class="tipos-veiculo-state tipos-veiculo-state--erro" role="alert">
      <p class="tipos-veiculo-state-message">{{ error }}</p>
      <button type="button" class="tipos-veiculo-retry" @click="carregar">Tentar novamente</button>
    </div>

    <TiposVeiculoEmptyState
      v-else-if="tipos.length === 0"
      :acao="true"
      @action="abrirCriacao"
    />

    <TiposVeiculoEmptyState
      v-else-if="tiposFiltrados.length === 0"
      title="Nenhum tipo encontrado"
      description="Ajuste a busca e tente novamente."
    />

    <TiposVeiculoTable
      v-else
      :tipos="tiposFiltrados"
      :excluindo-id="excluindoId"
      @editar="abrirEdicao"
      @excluir="solicitarExclusao"
    />

    <TipoVeiculoModal
      v-if="modalAberto"
      :mode="modalMode"
      :tipo="tipoEdicao"
      :loading="salvando"
      :error="modalError"
      @close="fecharModal"
      @save="salvar"
    />

    <TipoVeiculoConfirmModal
      v-if="exclusao"
      titulo="Excluir tipo de veículo"
      mensagem="Tem certeza que deseja excluir este tipo de veículo? Tipos vinculados a veículos não podem ser excluídos."
      confirm-label="Excluir"
      :loading="excluindo"
      :error="exclusaoError"
      @confirm="confirmarExclusao"
      @close="fecharExclusao"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import TiposVeiculoPageHeader from '@/components/tipos-veiculo/TiposVeiculoPageHeader.vue'
import TiposVeiculoSummary from '@/components/tipos-veiculo/TiposVeiculoSummary.vue'
import TiposVeiculoSearch from '@/components/tipos-veiculo/TiposVeiculoSearch.vue'
import TiposVeiculoTable from '@/components/tipos-veiculo/TiposVeiculoTable.vue'
import TiposVeiculoEmptyState from '@/components/tipos-veiculo/TiposVeiculoEmptyState.vue'
import TipoVeiculoModal from '@/components/tipos-veiculo/TipoVeiculoModal.vue'
import TipoVeiculoConfirmModal from '@/components/tipos-veiculo/TipoVeiculoConfirmModal.vue'
import { useTiposVeiculo } from '@/composables/useTiposVeiculo'
import {
  tipoCorrespondeBusca,
  type TipoVeiculo,
  type TipoVeiculoFormData
} from '@/utils/tiposVeiculo'

definePageMeta({
  layout: 'default'
})

const {
  tipos,
  loading,
  error,
  salvando,
  excluindoId,
  carregar,
  criarTipo,
  atualizarTipo,
  excluirTipo
} = useTiposVeiculo()

const busca = ref('')
const feedback = ref<{ type: 'success' | 'error'; message: string } | null>(null)

const modalAberto = ref(false)
const modalMode = ref<'create' | 'edit'>('create')
const tipoEdicao = ref<TipoVeiculo | null>(null)
const modalError = ref<string | null>(null)

const exclusao = ref<TipoVeiculo | null>(null)
const exclusaoError = ref<string | null>(null)

const summary = computed(() => ({ total: tipos.value.length }))
const tiposFiltrados = computed(() =>
  tipos.value.filter((tipo) => tipoCorrespondeBusca(tipo, busca.value))
)
const excluindo = computed(() => excluindoId.value !== null)

const abrirCriacao = () => {
  modalMode.value = 'create'
  tipoEdicao.value = null
  modalError.value = null
  modalAberto.value = true
}

const abrirEdicao = (tipo: TipoVeiculo) => {
  modalMode.value = 'edit'
  tipoEdicao.value = { ...tipo }
  modalError.value = null
  modalAberto.value = true
}

const fecharModal = () => {
  modalAberto.value = false
  modalError.value = null
}

const salvar = async (data: TipoVeiculoFormData) => {
  modalError.value = null

  const atual = tipoEdicao.value
  const editando = modalMode.value === 'edit' && atual !== null
  const resultado = editando && atual
    ? await atualizarTipo(atual.id, data)
    : await criarTipo(data)

  if (!resultado.success) {
    modalError.value = resultado.error
    return
  }

  fecharModal()
  feedback.value = {
    type: 'success',
    message: editando ? 'Tipo atualizado com sucesso.' : 'Tipo cadastrado com sucesso.'
  }
}

const solicitarExclusao = (tipo: TipoVeiculo) => {
  exclusaoError.value = null
  exclusao.value = tipo
}

const fecharExclusao = () => {
  exclusao.value = null
  exclusaoError.value = null
}

const confirmarExclusao = async () => {
  if (!exclusao.value) {
    return
  }

  exclusaoError.value = null
  const resultado = await excluirTipo(exclusao.value.id)

  if (!resultado.success) {
    exclusaoError.value = resultado.error
    return
  }

  feedback.value = { type: 'success', message: 'Tipo excluído com sucesso.' }
  fecharExclusao()
}

onMounted(carregar)
</script>

<style scoped>
.tipos-veiculo-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.tipos-veiculo-feedback {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 14px;
}

.tipos-veiculo-feedback--success {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.tipos-veiculo-feedback--error {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.tipos-veiculo-feedback-close {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border: none;
  background: transparent;
  cursor: pointer;
  color: inherit;
  border-radius: 6px;
  flex-shrink: 0;
}

.tipos-veiculo-feedback-close:hover {
  background: rgba(0, 0, 0, 0.06);
}

.tipos-veiculo-feedback-close svg {
  width: 16px;
  height: 16px;
}

.tipos-veiculo-state {
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

.tipos-veiculo-state--erro {
  color: #4b5563;
}

.tipos-veiculo-state-message {
  margin: 0;
}

.tipos-veiculo-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: tipos-veiculo-spin 0.8s linear infinite;
}

@keyframes tipos-veiculo-spin {
  to {
    transform: rotate(360deg);
  }
}

.tipos-veiculo-retry {
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

.tipos-veiculo-retry:hover {
  background: #e8f0fe;
}

@media (max-width: 1024px) {
  .tipos-veiculo-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .tipos-veiculo-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>
