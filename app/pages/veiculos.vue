<template>
  <div class="veiculos-page">
    <VeiculosPageHeader @new-veiculo="abrirCriacao" />
    <VeiculosSummary :summary="summary" />
    <VeiculosSearch v-model="filtros.busca" />
    <VeiculosFilters
      v-model:tipo="filtros.tipoId"
      v-model:situacao="filtros.situacao"
      :tipos="tipos"
    />

    <div
      v-if="feedback"
      class="veiculos-feedback"
      :class="`veiculos-feedback--${feedback.type}`"
      role="status"
    >
      <span>{{ feedback.message }}</span>
      <button type="button" class="veiculos-feedback-close" aria-label="Fechar" @click="feedback = null">
        <XMarkIcon aria-hidden="true" />
      </button>
    </div>

    <div v-if="loading" class="veiculos-state">
      <span class="veiculos-spinner" aria-hidden="true" />
      <span>Carregando veículos...</span>
    </div>

    <div v-else-if="error" class="veiculos-state veiculos-state--erro" role="alert">
      <p class="veiculos-state-message">{{ error }}</p>
      <button type="button" class="veiculos-retry" @click="carregar">Tentar novamente</button>
    </div>

    <VeiculosEmptyState
      v-else-if="veiculos.length === 0"
      title="Não há veículos cadastrados"
      description="Os veículos cadastrados na frota aparecerão aqui."
    />

    <VeiculosEmptyState
      v-else-if="veiculosFiltrados.length === 0"
      title="Nenhum veículo encontrado"
      description="Ajuste a busca ou os filtros e tente novamente."
    />

    <VeiculosTable
      v-else
      :veiculos="veiculosPagina"
      :saving-id="savingId"
      :page="pagina"
      :page-size="PAGE_SIZE"
      :total="veiculosFiltrados.length"
      @visualizar="abrirVisualizacao"
      @editar="abrirEdicao"
      @alterar-ativo="solicitarAlteracaoAtivo"
      @update:page="pagina = $event"
    />

    <VeiculoModal
      v-if="modalAberto"
      :mode="modalMode"
      :veiculo="veiculoSelecionado"
      :tipos="tipos"
      :saving="saving"
      :error="modalError"
      @close="fecharModal"
      @submit="salvar"
    />

    <VeiculoConfirmModal
      v-if="confirmacao"
      :titulo="confirmacao.acao === 'inativar' ? 'Inativar veículo' : 'Ativar veículo'"
      :mensagem="
        confirmacao.acao === 'inativar'
          ? 'Este veículo deixará de aparecer como ativo no cadastro. O histórico existente será preservado.'
          : 'Este veículo voltará a aparecer como ativo no cadastro.'
      "
      :confirm-label="confirmacao.acao === 'inativar' ? 'Inativar' : 'Ativar'"
      :variante="confirmacao.acao === 'inativar' ? 'danger' : 'default'"
      :loading="confirmLoading"
      :error="confirmError"
      @confirm="confirmarAlteracaoAtivo"
      @close="fecharConfirmacao"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import VeiculosPageHeader from '@/components/veiculos/VeiculosPageHeader.vue'
import VeiculosSummary from '@/components/veiculos/VeiculosSummary.vue'
import VeiculosSearch from '@/components/veiculos/VeiculosSearch.vue'
import VeiculosFilters from '@/components/veiculos/VeiculosFilters.vue'
import VeiculosTable from '@/components/veiculos/VeiculosTable.vue'
import VeiculosEmptyState from '@/components/veiculos/VeiculosEmptyState.vue'
import VeiculoModal from '@/components/veiculos/VeiculoModal.vue'
import VeiculoConfirmModal from '@/components/veiculos/VeiculoConfirmModal.vue'
import { useVeiculos } from '@/composables/useVeiculos'
import {
  VEICULOS_PAGE_SIZE,
  veiculoCorrespondeFiltros,
  type Veiculo,
  type VeiculoFiltros,
  type VeiculoFormData
} from '@/utils/veiculos'

definePageMeta({
  layout: 'default'
})

type ModalMode = 'create' | 'edit' | 'view'

const PAGE_SIZE = VEICULOS_PAGE_SIZE

const {
  veiculos,
  tipos,
  loading,
  error,
  saving,
  savingId,
  carregar,
  criarVeiculo,
  atualizarVeiculo,
  alterarAtivo
} = useVeiculos()

const filtros = reactive<VeiculoFiltros>({ busca: '', tipoId: '', situacao: 'TODOS' })
const pagina = ref(1)
const feedback = ref<{ type: 'success' | 'error'; message: string } | null>(null)

const modalAberto = ref(false)
const modalMode = ref<ModalMode>('create')
const veiculoSelecionado = ref<Veiculo | null>(null)
const modalError = ref<string | null>(null)

const confirmacao = ref<{ veiculo: Veiculo; acao: 'ativar' | 'inativar' } | null>(null)
const confirmLoading = ref(false)
const confirmError = ref<string | null>(null)

const summary = computed(() => ({
  total: veiculos.value.length,
  ativos: veiculos.value.filter((veiculo) => veiculo.ativo).length,
  inativos: veiculos.value.filter((veiculo) => !veiculo.ativo).length,
  tipos: tipos.value.length
}))

const veiculosFiltrados = computed(() =>
  veiculos.value.filter((veiculo) => veiculoCorrespondeFiltros(veiculo, filtros))
)

const totalPaginas = computed(() =>
  Math.max(1, Math.ceil(veiculosFiltrados.value.length / PAGE_SIZE))
)

const veiculosPagina = computed(() => {
  const inicio = (pagina.value - 1) * PAGE_SIZE
  return veiculosFiltrados.value.slice(inicio, inicio + PAGE_SIZE)
})

watch(filtros, () => {
  pagina.value = 1
})

watch(totalPaginas, (max) => {
  if (pagina.value > max) {
    pagina.value = max
  }
})

const abrirCriacao = () => {
  modalMode.value = 'create'
  veiculoSelecionado.value = null
  modalError.value = null
  modalAberto.value = true
}

const abrirEdicao = (veiculo: Veiculo) => {
  modalMode.value = 'edit'
  veiculoSelecionado.value = veiculo
  modalError.value = null
  modalAberto.value = true
}

const abrirVisualizacao = (veiculo: Veiculo) => {
  modalMode.value = 'view'
  veiculoSelecionado.value = veiculo
  modalError.value = null
  modalAberto.value = true
}

const fecharModal = () => {
  modalAberto.value = false
  modalError.value = null
}

const salvar = async (data: VeiculoFormData) => {
  modalError.value = null

  const atual = veiculoSelecionado.value
  const editando = modalMode.value === 'edit' && atual !== null

  const resultado = editando && atual
    ? await atualizarVeiculo(atual.id, data)
    : await criarVeiculo(data)

  if (!resultado.success) {
    modalError.value = resultado.error
    return
  }

  fecharModal()
  feedback.value = {
    type: 'success',
    message: editando ? 'Veículo atualizado com sucesso.' : 'Veículo cadastrado com sucesso.'
  }
}

const solicitarAlteracaoAtivo = (veiculo: Veiculo) => {
  confirmError.value = null
  confirmacao.value = { veiculo, acao: veiculo.ativo ? 'inativar' : 'ativar' }
}

const fecharConfirmacao = () => {
  confirmacao.value = null
  confirmError.value = null
}

const confirmarAlteracaoAtivo = async () => {
  if (!confirmacao.value) {
    return
  }

  confirmError.value = null
  confirmLoading.value = true

  const { veiculo, acao } = confirmacao.value
  const resultado = await alterarAtivo(veiculo.id, acao === 'ativar')

  confirmLoading.value = false

  if (!resultado.success) {
    confirmError.value = resultado.error
    return
  }

  feedback.value = {
    type: 'success',
    message: acao === 'ativar' ? 'Veículo ativado com sucesso.' : 'Veículo inativado com sucesso.'
  }
  fecharConfirmacao()
}

onMounted(() => {
  carregar()
})
</script>

<style scoped>
.veiculos-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.veiculos-feedback {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 14px;
}

.veiculos-feedback--success {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.veiculos-feedback--error {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.veiculos-feedback-close {
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

.veiculos-feedback-close:hover {
  background: rgba(0, 0, 0, 0.06);
}

.veiculos-feedback-close svg {
  width: 16px;
  height: 16px;
}

.veiculos-state {
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

.veiculos-state--erro {
  color: #4b5563;
}

.veiculos-state-message {
  margin: 0;
}

.veiculos-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: veiculos-spin 0.8s linear infinite;
}

@keyframes veiculos-spin {
  to {
    transform: rotate(360deg);
  }
}

.veiculos-retry {
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

.veiculos-retry:hover {
  background: #e8f0fe;
}

@media (max-width: 1024px) {
  .veiculos-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .veiculos-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>
