<template>
  <div class="reservas-page">
    <ReservasPageHeader />
    <ReservasSummary :summary="summary" />
    <ReservasSearch v-model="filtros.busca" />
    <ReservasFilters
      v-model:data-inicial="filtros.dataInicial"
      v-model:data-final="filtros.dataFinal"
      v-model:status="filtros.status"
      v-model:tipo-id="filtros.tipoId"
      :tipos="tipos"
      :pode-limpar="podeLimpar"
      @limpar="limparFiltros"
    />

    <div
      v-if="feedback"
      class="reservas-feedback"
      :class="`reservas-feedback--${feedback.type}`"
      role="status"
    >
      <span>{{ feedback.message }}</span>
      <button type="button" class="reservas-feedback-close" aria-label="Fechar" @click="feedback = null">
        <XMarkIcon aria-hidden="true" />
      </button>
    </div>

    <div v-if="loading" class="reservas-state">
      <span class="reservas-spinner" aria-hidden="true" />
      <span>Carregando reservas...</span>
    </div>

    <div v-else-if="error" class="reservas-state reservas-state--erro" role="alert">
      <p class="reservas-state-message">{{ error }}</p>
      <button type="button" class="reservas-retry" @click="carregar">Tentar novamente</button>
    </div>

    <ReservasEmptyState
      v-else-if="reservas.length === 0"
      title="Nenhuma reserva cadastrada"
      description="Quando houver reservas cadastradas, elas aparecerão aqui."
    />

    <ReservasEmptyState
      v-else-if="reservasFiltradas.length === 0"
      title="Nenhum resultado encontrado"
      description="Ajuste a busca ou os filtros e tente novamente."
    />

    <ReservasTable
      v-else
      :reservas="reservasPagina"
      :page="pagina"
      :page-size="PAGE_SIZE"
      :total="reservasFiltradas.length"
      :pode-cancelar="podeCancelar"
      :cancelando-id="cancelandoId"
      @visualizar="abrirDetalhes"
      @cancelar="solicitarCancelamento"
      @update:page="pagina = $event"
    />

    <ReservaDetalhesModal
      v-if="detalhesAberto && reservaSelecionada"
      :reserva="reservaSelecionada"
      :eventos="eventos"
      :loading="loadingDetalhes"
      @close="fecharDetalhes"
    />

    <AgendaActionModal
      v-if="cancelamento"
      titulo="Cancelar reserva"
      mensagem="Esta reserva será marcada como cancelada. Deseja continuar?"
      :veiculo="cancelamento.veiculo"
      :placa="cancelamento.placa"
      confirm-label="Cancelar reserva"
      variante="danger"
      :loading="cancelando"
      :error="cancelError"
      @confirm="confirmarCancelamento"
      @close="fecharCancelamento"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import ReservasPageHeader from '@/components/reservas/ReservasPageHeader.vue'
import ReservasSummary from '@/components/reservas/ReservasSummary.vue'
import ReservasSearch from '@/components/reservas/ReservasSearch.vue'
import ReservasFilters from '@/components/reservas/ReservasFilters.vue'
import ReservasTable from '@/components/reservas/ReservasTable.vue'
import ReservasEmptyState from '@/components/reservas/ReservasEmptyState.vue'
import ReservaDetalhesModal from '@/components/reservas/ReservaDetalhesModal.vue'
import AgendaActionModal from '@/components/agenda/AgendaActionModal.vue'
import { useReservasAdmin } from '@/composables/useReservasAdmin'
import { useAuth } from '@/composables/useAuth'
import {
  RESERVAS_PAGE_SIZE,
  filtrosIniciais,
  reservaCorrespondeFiltros,
  temFiltrosAtivos,
  type EventoReserva,
  type ReservaAdmin,
  type ReservaAdminFiltros
} from '@/utils/reservasAdmin'

definePageMeta({
  layout: 'default'
})

const PAGE_SIZE = RESERVAS_PAGE_SIZE

const {
  reservas,
  tipos,
  loading,
  error,
  loadingDetalhes,
  cancelandoId,
  carregar,
  carregarEventos,
  cancelarReserva
} = useReservasAdmin()

const { acessoPerfil } = useAuth()

const filtros = reactive<ReservaAdminFiltros>({
  busca: '',
  dataInicial: '',
  dataFinal: '',
  status: '',
  tipoId: ''
})

const pagina = ref(1)
const feedback = ref<{ type: 'success' | 'error'; message: string } | null>(null)

const reservaSelecionada = ref<ReservaAdmin | null>(null)
const eventos = ref<EventoReserva[]>([])
const detalhesAberto = ref(false)

const cancelamento = ref<ReservaAdmin | null>(null)
const cancelError = ref<string | null>(null)

const podeCancelar = computed(() => acessoPerfil.value === 'ADMIN')
const cancelando = computed(() => cancelandoId.value !== null)

const summary = computed(() => ({
  total: reservas.value.length,
  reserved: reservas.value.filter((reserva) => reserva.status === 'RESERVADA').length,
  washing: reservas.value.filter((reserva) => reserva.status === 'EM_LAVAGEM').length,
  completed: reservas.value.filter((reserva) => reserva.status === 'CONCLUIDA').length
}))

const reservasFiltradas = computed(() =>
  reservas.value.filter((reserva) => reservaCorrespondeFiltros(reserva, filtros))
)

const totalPaginas = computed(() =>
  Math.max(1, Math.ceil(reservasFiltradas.value.length / PAGE_SIZE))
)

const reservasPagina = computed(() => {
  const inicio = (pagina.value - 1) * PAGE_SIZE
  return reservasFiltradas.value.slice(inicio, inicio + PAGE_SIZE)
})

watch(filtros, () => {
  pagina.value = 1
})

watch(totalPaginas, (max) => {
  if (pagina.value > max) {
    pagina.value = max
  }
})

const podeLimpar = computed(() => temFiltrosAtivos(filtros))

const limparFiltros = () => {
  Object.assign(filtros, filtrosIniciais())
  pagina.value = 1
}

const abrirDetalhes = async (reserva: ReservaAdmin) => {
  reservaSelecionada.value = reserva
  eventos.value = []
  detalhesAberto.value = true
  eventos.value = await carregarEventos(reserva.id)
}

const fecharDetalhes = () => {
  detalhesAberto.value = false
  reservaSelecionada.value = null
  eventos.value = []
}

const solicitarCancelamento = (reserva: ReservaAdmin) => {
  cancelError.value = null
  cancelamento.value = reserva
}

const fecharCancelamento = () => {
  cancelamento.value = null
  cancelError.value = null
}

const confirmarCancelamento = async (payload: { motivo: string | null; observacao: string }) => {
  if (!cancelamento.value) {
    return
  }

  cancelError.value = null
  const resultado = await cancelarReserva(cancelamento.value.id, payload.observacao)

  if (!resultado.success) {
    cancelError.value = resultado.error
    return
  }

  feedback.value = { type: 'success', message: 'Reserva cancelada com sucesso.' }
  fecharCancelamento()
}

onMounted(() => {
  carregar()
})
</script>

<style scoped>
.reservas-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.reservas-feedback {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 14px;
}

.reservas-feedback--success {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.reservas-feedback--error {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.reservas-feedback-close {
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

.reservas-feedback-close:hover {
  background: rgba(0, 0, 0, 0.06);
}

.reservas-feedback-close svg {
  width: 16px;
  height: 16px;
}

.reservas-state {
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

.reservas-state--erro {
  color: #4b5563;
}

.reservas-state-message {
  margin: 0;
}

.reservas-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: reservas-spin 0.8s linear infinite;
}

@keyframes reservas-spin {
  to {
    transform: rotate(360deg);
  }
}

.reservas-retry {
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

.reservas-retry:hover {
  background: #e8f0fe;
}

@media (max-width: 1024px) {
  .reservas-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .reservas-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>
