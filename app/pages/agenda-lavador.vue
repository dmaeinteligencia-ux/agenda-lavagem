<template>
  <div class="agenda-page">
    <AgendaPageHeader :date="selectedDate" @prev="goPrev" @next="goNext" @today="goToday" />
    <AgendaFilters
      v-model:tipo="filtroTipo"
      v-model:status="filtroStatus"
      v-model:regime="filtroRegime"
      :tipos="tiposDisponiveis"
    />
    <AgendaSummary
      :capacidade="capacidadeMinutos"
      :utilizado="utilizadoMinutos"
      :disponivel="disponivelMinutos"
      :reservas="qtdReservas"
      :dia-ativo="diaAtivo"
    />
    <div class="agenda-main-grid">
      <div class="agenda-main-left">
        <div v-if="loading" class="agenda-state-card">
          <span class="agenda-spinner" aria-hidden="true" />
          <span>Carregando agenda...</span>
        </div>

        <div v-else-if="error" class="agenda-state-card" role="alert">
          <p class="agenda-state-message">{{ error }}</p>
          <button type="button" class="agenda-retry" @click="fetchReservas">Tentar novamente</button>
        </div>

        <AgendaTimeline
          v-else
          :items="itemsFiltrados"
          :regime="regime"
          :disponivel-minutos="disponivelMinutos"
          :perfil="perfil"
          :tem-acesso="temAcesso"
          :action-loading-id="actionLoadingId"
          @acao="abrirAcao"
        />
      </div>
      <div class="agenda-main-right">
        <AgendaNewReservationButton class="agenda-new-reservation" />
        <AgendaDayDetails
          class="agenda-day-details-panel"
          :data="selectedDate"
          :regime="regime"
          :dia-ativo="diaAtivo"
          :progresso="progressoTexto"
          :situacao-atual="situacaoAtual"
          :pendencias="pendencias"
          :tem-pendencias="temPendencias"
        />
      </div>
    </div>

    <AgendaActionModal
      v-if="acaoAtiva"
      :titulo="acaoAtiva.titulo"
      :mensagem="acaoAtiva.mensagem"
      :veiculo="acaoAtiva.item.vehicle"
      :placa="acaoAtiva.item.plate"
      :confirm-label="acaoAtiva.confirmLabel"
      :variante="acaoAtiva.variante"
      :motivos="acaoAtiva.motivos"
      :loading="actionLoadingId === acaoAtiva.item.id"
      :error="actionError"
      @confirm="confirmarAcao"
      @close="fecharModal"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import AgendaPageHeader from '@/components/agenda/AgendaPageHeader.vue'
import AgendaFilters from '@/components/agenda/AgendaFilters.vue'
import AgendaSummary from '@/components/agenda/AgendaSummary.vue'
import AgendaTimeline from '@/components/agenda/AgendaTimeline.vue'
import AgendaDayDetails from '@/components/agenda/AgendaDayDetails.vue'
import AgendaNewReservationButton from '@/components/agenda/AgendaNewReservationButton.vue'
import AgendaActionModal from '@/components/agenda/AgendaActionModal.vue'
import { useReservas } from '@/composables/useReservas'
import {
  resumoStatusDia,
  mapReservaToAgendaItem,
  motivosNaoAtendimento,
  motivosNaoConclusao,
  type AcaoChave,
  type AgendaReservaItem,
  type MotivoOpcao
} from '@/utils/reservas'
import type { Perfil } from '@/utils/accessControl'

definePageMeta({
  layout: 'default'
})

const {
  selectedDate,
  reservas,
  horarios,
  capacidade,
  diaOperacional,
  loading,
  error,
  fetchReservas,
  goPrev,
  goNext,
  goToday,
  iniciarLavagem,
  concluirLavagem,
  cancelarReserva,
  registrarNaoComparecimento,
  registrarNaoAtendimento,
  registrarNaoConclusao
} = useReservas()

const { fetchMyProfile } = useAuth()

const perfil = ref<Perfil | null>(null)
const temAcesso = ref(false)
const actionLoadingId = ref<string | null>(null)
const actionError = ref<string | null>(null)

interface AcaoAtiva {
  chave: AcaoChave
  item: AgendaReservaItem
  titulo: string
  mensagem: string
  confirmLabel: string
  variante: 'default' | 'danger'
  motivos?: MotivoOpcao[]
}

const acaoAtiva = ref<AcaoAtiva | null>(null)

const filtroTipo = ref('')
const filtroStatus = ref('')
const filtroRegime = ref('')

const items = computed(() => {
  const ordenadas = [...reservas.value].sort((a, b) => {
    const ia = horarios.value.get(a.id)?.inicioRaw ?? null
    const ib = horarios.value.get(b.id)?.inicioRaw ?? null

    if (ia && ib) return ia.localeCompare(ib)
    if (ia) return -1
    if (ib) return 1
    return a.created_at.localeCompare(b.created_at)
  })

  return ordenadas.map((r) => mapReservaToAgendaItem(r, horarios.value.get(r.id)))
})

const tiposDisponiveis = computed(() => {
  const tipos = new Set<string>()
  for (const r of reservas.value) {
    if (r.tipoVeiculo) {
      tipos.add(r.tipoVeiculo)
    }
  }
  return Array.from(tipos).sort()
})

const itemsFiltrados = computed(() => {
  return items.value.filter((item) => {
    if (filtroTipo.value && item.type !== filtroTipo.value) return false
    if (filtroStatus.value && item.status !== filtroStatus.value) return false
    return true
  })
})

const capacidadeMinutos = computed(() => capacidade.value?.capacidadeMinutos ?? 0)
const utilizadoMinutos = computed(() => capacidade.value?.reservadoMinutos ?? 0)
const disponivelMinutos = computed(() => capacidade.value?.disponivelMinutos ?? null)
const regime = computed(() => capacidade.value?.regime ?? null)
const diaAtivo = computed(() => (diaOperacional.value ? diaOperacional.value.ativo : null))
const qtdReservas = computed(() => reservas.value.length)

const resumoDia = computed(() => resumoStatusDia(reservas.value.map((reserva) => reserva.status)))

const progressoTexto = computed(() => {
  if (resumoDia.value.total === 0) {
    return '0 reservas neste dia'
  }
  return `${resumoDia.value.finalizadas} de ${resumoDia.value.total} reservas finalizadas`
})

const situacaoAtual = computed(() => {
  const partes: string[] = []

  if (resumoDia.value.aguardando > 0) {
    partes.push(`${resumoDia.value.aguardando} aguardando início`)
  }
  if (resumoDia.value.emLavagem > 0) {
    partes.push(`${resumoDia.value.emLavagem} em lavagem`)
  }

  return partes.length > 0 ? partes.join(' · ') : 'Sem reservas em andamento.'
})

const pendenciasPartes = computed(() => {
  const partes: string[] = []
  const { naoAtendida, naoConcluida, naoCompareceu, expirada } = resumoDia.value

  if (naoAtendida > 0) {
    partes.push(`${naoAtendida} não atendida${naoAtendida > 1 ? 's' : ''}`)
  }
  if (naoConcluida > 0) {
    partes.push(`${naoConcluida} não concluída${naoConcluida > 1 ? 's' : ''}`)
  }
  if (naoCompareceu > 0) {
    partes.push(`${naoCompareceu} não compareceu`)
  }
  if (expirada > 0) {
    partes.push(`${expirada} expirada${expirada > 1 ? 's' : ''}`)
  }

  return partes
})

const pendencias = computed(() =>
  pendenciasPartes.value.length > 0
    ? pendenciasPartes.value.join(' · ')
    : 'Sem pendências operacionais.'
)

const temPendencias = computed(() => pendenciasPartes.value.length > 0)

function abrirAcao(chave: AcaoChave, item: AgendaReservaItem) {
  actionError.value = null

  const metadados: Record<AcaoChave, Omit<AcaoAtiva, 'chave' | 'item'>> = {
    iniciar: {
      titulo: 'Iniciar lavagem',
      mensagem: 'Iniciar a lavagem deste veículo?',
      confirmLabel: 'Iniciar',
      variante: 'default'
    },
    concluir: {
      titulo: 'Concluir lavagem',
      mensagem: 'Confirmar a conclusão desta lavagem?',
      confirmLabel: 'Concluir',
      variante: 'default'
    },
    cancelar: {
      titulo: 'Cancelar reserva',
      mensagem: 'A reserva será cancelada e o status será alterado para CANCELADA.',
      confirmLabel: 'Cancelar reserva',
      variante: 'danger'
    },
    nao_comparecimento: {
      titulo: 'Não compareceu',
      mensagem: 'Confirmar que o veículo não compareceu para a lavagem?',
      confirmLabel: 'Confirmar',
      variante: 'default'
    },
    nao_atendimento: {
      titulo: 'Registrar como não atendida',
      mensagem: 'Informe o motivo pelo qual esta reserva não pôde ser atendida.',
      confirmLabel: 'Registrar',
      variante: 'default',
      motivos: motivosNaoAtendimento
    },
    nao_conclusao: {
      titulo: 'Registrar lavagem não concluída',
      mensagem: 'Informe o motivo pelo qual a lavagem iniciada não foi concluída.',
      confirmLabel: 'Registrar',
      variante: 'default',
      motivos: motivosNaoConclusao
    }
  }

  acaoAtiva.value = { chave, item, ...metadados[chave] }
}

function fecharModal() {
  acaoAtiva.value = null
  actionError.value = null
}

async function confirmarAcao(payload: { motivo: string | null; observacao: string }) {
  if (!acaoAtiva.value) {
    return
  }

  const { chave, item } = acaoAtiva.value

  actionLoadingId.value = item.id
  actionError.value = null

  let resultado: { success: boolean; message: string | null }

  switch (chave) {
    case 'iniciar':
      resultado = await iniciarLavagem(item.id, payload.observacao)
      break
    case 'concluir':
      resultado = await concluirLavagem(item.id, payload.observacao)
      break
    case 'cancelar':
      resultado = await cancelarReserva(item.id, payload.observacao)
      break
    case 'nao_comparecimento':
      resultado = await registrarNaoComparecimento(item.id, payload.observacao)
      break
    case 'nao_atendimento':
      resultado = await registrarNaoAtendimento(item.id, payload.motivo ?? '', payload.observacao)
      break
    case 'nao_conclusao':
      resultado = await registrarNaoConclusao(item.id, payload.motivo ?? '', payload.observacao)
      break
  }

  actionLoadingId.value = null

  if (!resultado.success) {
    actionError.value = resultado.message ?? 'Não foi possível concluir a operação.'
    return
  }

  acaoAtiva.value = null
  actionError.value = null
  await fetchReservas()
}

onMounted(async () => {
  const { profile } = await fetchMyProfile()

  if (profile) {
    perfil.value = profile.perfil as Perfil
    temAcesso.value = profile.status_acesso === 'ATIVO'
  }

  await fetchReservas()
})
</script>

<style scoped>
.agenda-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.agenda-main-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
}

.agenda-main-left {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.agenda-main-right {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.agenda-state-card {
  background: #fff;
  border-radius: 12px;
  padding: 40px 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 12px;
  color: #6b7280;
  font-size: 14px;
  text-align: center;
}

.agenda-state-message {
  margin: 0;
}

.agenda-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: agenda-spin 0.8s linear infinite;
}

@keyframes agenda-spin {
  to {
    transform: rotate(360deg);
  }
}

.agenda-retry {
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

.agenda-retry:hover {
  background: #e8f0fe;
}

@media (max-width: 1024px) {
  .agenda-main-grid {
    grid-template-columns: 1fr;
  }

  /* Mobile/tablet: reordena para Nova Reserva -> Agenda do Dia -> Resumo operacional,
     sem duplicar o botão no DOM. */
  .agenda-main-right {
    display: contents;
  }

  .agenda-new-reservation {
    order: 1;
  }

  .agenda-main-left {
    order: 2;
  }

  .agenda-day-details-panel {
    order: 3;
  }

  .agenda-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .agenda-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>
