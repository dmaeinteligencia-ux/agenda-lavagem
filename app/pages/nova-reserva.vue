<template>
  <div class="nova-reserva-page">
    <NovaReservaPageHeader />
    <NovaReservaSteps :steps="steps" :current="currentStep" />

    <div v-if="reservaCriada" class="nova-reserva-success" role="status">
      <div class="nova-reserva-success-icon">
        <CheckCircleIcon aria-hidden="true" />
      </div>
      <div class="nova-reserva-success-body">
        <h2 class="nova-reserva-success-title">Reserva criada com sucesso</h2>
        <p class="nova-reserva-success-text">
          Veículo {{ veiculoDisplay.plate }} · {{ veiculoDisplay.identification }} ·
          {{ dataFormatada }} · {{ reservaCriada.tempo_estimado }} min · {{ reservaCriada.status }}
        </p>
      </div>
      <NuxtLink to="/agenda-lavador" class="nova-reserva-success-link">Ver na Agenda</NuxtLink>
    </div>

    <div class="nova-reserva-grid">
      <div class="nova-reserva-column">
        <NovaReservaSolicitanteCard
          :key="`solicitante-${formKey}`"
          :solicitante="solicitante"
          :loading="buscandoSolicitante"
          :error="erroSolicitante"
          :nao-encontrado="solicitanteNaoEncontrado"
          :sucesso="sucessoSolicitante"
          @buscar="aoBuscarSolicitante"
          @cadastrar="abrirCadastroSolicitante"
        />
        <NovaReservaVehicleCard
          :key="`veiculo-${formKey}`"
          :vehicle="veiculoDisplay"
          :loading="buscandoVeiculo"
          :error="erroVeiculo"
          @buscar="aoBuscarVeiculo"
        />
        <NovaReservaDateCard
          :date="dataReserva"
          :regime="regimeDisplay"
          :min-date="minDate"
          @update:date="aoMudarData"
        />
      </div>
      <div class="nova-reserva-column">
        <NovaReservaAvailabilityCard
          :capacity="capacidadeDisplay"
          :utilization="utilizacao"
          :utilization-percent="utilizacaoPercent"
          :estimated-time="tempoEstimado"
          :availability="disponibilidadeStatus"
          :data-inativa="dataInativa"
        />
        <NovaReservaSummaryCard
          :vehicle="veiculoDisplay"
          :date="dataFormatada"
          :regime="regimeDisplay"
          :estimated-time="tempoEstimado"
          :observacao="observacao"
          @update:observacao="observacao = $event"
        />
      </div>
    </div>

    <p v-if="erroGeral" class="nova-reserva-geral-erro" role="alert">{{ erroGeral }}</p>

    <NovaReservaActions
      v-if="!reservaCriada"
      :disabled="!podeConfirmar"
      :loading="criandoReserva"
      @confirmar="aoConfirmar"
      @cancelar="aoCancelar"
    />

    <NovaReservaSolicitanteCadastroModal
      v-if="modalCadastroAberto"
      :matricula="matriculaCadastro"
      :loading="cadastrandoSolicitante"
      :error="erroCadastro"
      @close="fecharCadastroSolicitante"
      @salvar="aoSalvarCadastro"
    />

    <div v-if="mostrarConfirmacaoCancelar" class="nova-reserva-confirm-overlay" role="presentation">
      <div class="nova-reserva-confirm-modal" role="dialog" aria-modal="true" aria-labelledby="nova-reserva-confirm-title">
        <h3 id="nova-reserva-confirm-title" class="nova-reserva-confirm-title">Cancelar nova reserva</h3>
        <p class="nova-reserva-confirm-text">Os dados preenchidos serão descartados. Deseja continuar?</p>
        <div class="nova-reserva-confirm-actions">
          <button type="button" class="nova-reserva-confirm-btn nova-reserva-confirm-btn--secondary" @click="mostrarConfirmacaoCancelar = false">
            Continuar preenchendo
          </button>
          <button type="button" class="nova-reserva-confirm-btn nova-reserva-confirm-btn--danger" @click="confirmarDescarte">
            Descartar
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { CheckCircleIcon } from '@heroicons/vue/24/outline'
import NovaReservaPageHeader from '@/components/nova-reserva/NovaReservaPageHeader.vue'
import NovaReservaSteps from '@/components/nova-reserva/NovaReservaSteps.vue'
import NovaReservaSolicitanteCard from '@/components/nova-reserva/NovaReservaSolicitanteCard.vue'
import NovaReservaSolicitanteCadastroModal from '@/components/nova-reserva/NovaReservaSolicitanteCadastroModal.vue'
import NovaReservaVehicleCard from '@/components/nova-reserva/NovaReservaVehicleCard.vue'
import NovaReservaDateCard from '@/components/nova-reserva/NovaReservaDateCard.vue'
import NovaReservaAvailabilityCard from '@/components/nova-reserva/NovaReservaAvailabilityCard.vue'
import NovaReservaSummaryCard from '@/components/nova-reserva/NovaReservaSummaryCard.vue'
import NovaReservaActions from '@/components/nova-reserva/NovaReservaActions.vue'
import { useNovaReserva } from '@/composables/useNovaReserva'
import { diaSemAtendimento, toISODate, type NovaReservaVehicle } from '@/utils/reservas'

definePageMeta({
  layout: 'default'
})

const {
  solicitante,
  veiculo,
  dataReserva,
  disponibilidade,
  reservaCriada,
  buscandoSolicitante,
  buscandoVeiculo,
  consultandoDisponibilidade,
  criandoReserva,
  cadastrandoSolicitante,
  buscarSolicitante,
  cadastrarSolicitante,
  buscarVeiculo,
  consultarDisponibilidade,
  criarReserva,
  resetNovaReserva
} = useNovaReserva()

const erroSolicitante = ref<string | null>(null)
const erroVeiculo = ref<string | null>(null)
const erroGeral = ref<string | null>(null)
const observacao = ref('')
const formKey = ref(0)
const mostrarConfirmacaoCancelar = ref(false)

const solicitanteNaoEncontrado = ref(false)
const sucessoSolicitante = ref<string | null>(null)
const modalCadastroAberto = ref(false)
const matriculaCadastro = ref('')
const erroCadastro = ref<string | null>(null)

const minDate = toISODate(new Date())

const steps = [
  { label: 'Solicitante' },
  { label: 'Veículo' },
  { label: 'Data' },
  { label: 'Disponibilidade' },
  { label: 'Resumo' }
]

const currentStep = computed(() => {
  if (reservaCriada.value) return 4
  if (disponibilidade.value) return 3
  if (veiculo.value) return 2
  if (solicitante.value) return 1
  return 0
})

const veiculoDisplay = computed<NovaReservaVehicle>(() => {
  if (!veiculo.value) {
    return { identification: '—', plate: '—', type: '—', model: '—' }
  }
  return {
    identification: veiculo.value.nome_frota || '—',
    plate: veiculo.value.nr_placa_transport,
    type: veiculo.value.tipo_veiculo_descricao || '—',
    model: veiculo.value.ds_modelo || '—',
    ativo: veiculo.value.ativo
  }
})

const dataFormatada = computed(() => {
  const [ano, mes, dia] = dataReserva.value.split('-')
  return `${dia}/${mes}/${ano}`
})

const regimeDisplay = computed(() => {
  const d = disponibilidade.value
  if (!d) return '—'
  return d.regime === 'PLANTAO' ? 'PLANTÃO' : d.regime
})

const capacidadeDisplay = computed(() => {
  const d = disponibilidade.value
  if (!d) return { total: '— min', used: '— min', available: '— min' }
  return {
    total: `${d.capacidade_minutos} min`,
    used: `${d.reservado_minutos} min`,
    available: `${d.disponivel_minutos} min`
  }
})

const utilizacaoPercent = computed(() => {
  const d = disponibilidade.value
  if (!d || d.capacidade_minutos <= 0) return 0
  return Math.round((d.reservado_minutos / d.capacidade_minutos) * 100)
})

const utilizacao = computed(() => {
  if (!disponibilidade.value) return '—'
  return `${utilizacaoPercent.value}% utilizado`
})

const tempoEstimado = computed(() => {
  const d = disponibilidade.value
  if (!d) return '—'
  return `${d.tempo_veiculo_minutos} minutos`
})

const disponibilidadeStatus = computed<'Disponível' | 'Indisponível'>(() => {
  const d = disponibilidade.value
  if (!d) return 'Indisponível'
  return d.disponivel ? 'Disponível' : 'Indisponível'
})

// Data sem atendimento: indisponível sem ser por capacidade/duplicidade.
const dataInativa = computed(() => {
  const d = disponibilidade.value
  const v = veiculo.value
  if (!d || !v) {
    return false
  }
  return diaSemAtendimento({
    disponivel: d.disponivel,
    veiculoAtivo: v.ativo,
    disponivelMinutos: d.disponivel_minutos,
    tempoVeiculoMinutos: d.tempo_veiculo_minutos,
    veiculoTemReserva: d.veiculo_tem_reserva
  })
})

const podeConfirmar = computed(() => {
  return (
    !!solicitante.value &&
    !!veiculo.value &&
    veiculo.value.ativo &&
    !!dataReserva.value &&
    !!disponibilidade.value &&
    disponibilidade.value.disponivel &&
    !disponibilidade.value.veiculo_tem_reserva &&
    !criandoReserva.value
  )
})

const formularioPreenchido = computed(() => {
  return (
    !!solicitante.value ||
    !!veiculo.value ||
    !!disponibilidade.value ||
    observacao.value.trim() !== ''
  )
})

async function aoBuscarSolicitante(matricula: string) {
  erroSolicitante.value = null
  sucessoSolicitante.value = null
  solicitanteNaoEncontrado.value = false

  const r = await buscarSolicitante(matricula)

  if (r.success) {
    return
  }

  if (r.naoEncontrado) {
    matriculaCadastro.value = matricula.trim()
    solicitanteNaoEncontrado.value = true
    return
  }

  erroSolicitante.value = r.message
}

function abrirCadastroSolicitante() {
  erroCadastro.value = null
  modalCadastroAberto.value = true
}

function fecharCadastroSolicitante() {
  modalCadastroAberto.value = false
  erroCadastro.value = null
}

async function aoSalvarCadastro(data: { nome: string; matricula: string; telefone: string }) {
  erroCadastro.value = null

  const r = await cadastrarSolicitante(data.nome, data.matricula, data.telefone)

  if (!r.success) {
    erroCadastro.value = r.message
    return
  }

  modalCadastroAberto.value = false
  solicitanteNaoEncontrado.value = false
  erroSolicitante.value = null
  sucessoSolicitante.value = 'Solicitante cadastrado com sucesso.'
}

async function aoBuscarVeiculo(placa: string) {
  erroVeiculo.value = null
  erroGeral.value = null
  const r = await buscarVeiculo(placa)
  if (!r.success) {
    erroVeiculo.value = r.message
  }
}

async function aoMudarData(novaData: string) {
  dataReserva.value = novaData
  erroGeral.value = null
}

async function aoConfirmar() {
  erroGeral.value = null
  const r = await criarReserva(observacao.value)
  if (!r.success) {
    erroGeral.value = r.message
  }
}

function aoCancelar() {
  if (formularioPreenchido.value) {
    mostrarConfirmacaoCancelar.value = true
    return
  }
  descartarFormulario()
}

function confirmarDescarte() {
  mostrarConfirmacaoCancelar.value = false
  descartarFormulario()
}

function descartarFormulario() {
  resetNovaReserva()
  erroSolicitante.value = null
  erroVeiculo.value = null
  erroGeral.value = null
  observacao.value = ''
  solicitanteNaoEncontrado.value = false
  sucessoSolicitante.value = null
  modalCadastroAberto.value = false
  matriculaCadastro.value = ''
  erroCadastro.value = null
  formKey.value += 1
}

watch([veiculo, dataReserva], async () => {
  if (!veiculo.value || !dataReserva.value) {
    return
  }

  // Veículo inativo: não consulta disponibilidade e mantém o fluxo bloqueado.
  if (!veiculo.value.ativo) {
    disponibilidade.value = null
    return
  }

  erroGeral.value = null
  const r = await consultarDisponibilidade()
  if (!r.success) {
    erroGeral.value = r.message
  }
})
</script>

<style scoped>
.nova-reserva-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.nova-reserva-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
  align-items: start;
}

.nova-reserva-column {
  display: flex;
  flex-direction: column;
  gap: 24px;
  min-width: 0;
}

.nova-reserva-success {
  display: flex;
  align-items: center;
  gap: 14px;
  flex-wrap: wrap;
  background: #d1fae5;
  border: 1px solid #bbf7d0;
  border-radius: 12px;
  padding: 16px 20px;
}

.nova-reserva-success-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: #10b981;
  color: #fff;
  flex-shrink: 0;
}

.nova-reserva-success-icon svg {
  width: 22px;
  height: 22px;
}

.nova-reserva-success-body {
  flex: 1;
  min-width: 200px;
}

.nova-reserva-success-title {
  margin: 0;
  font-size: 16px;
  font-weight: 700;
  color: #065f46;
}

.nova-reserva-success-text {
  margin: 4px 0 0;
  font-size: 13px;
  color: #065f46;
}

.nova-reserva-success-link {
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border-radius: 8px;
  text-decoration: none;
  white-space: nowrap;
}

.nova-reserva-success-link:hover {
  background-color: #003570;
}

.nova-reserva-geral-erro {
  margin: 0;
  padding: 12px 16px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 14px;
}

.nova-reserva-confirm-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.nova-reserva-confirm-modal {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 420px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.nova-reserva-confirm-title {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #111827;
}

.nova-reserva-confirm-text {
  margin: 0;
  font-size: 14px;
  color: #4b5563;
}

.nova-reserva-confirm-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 8px;
}

.nova-reserva-confirm-btn {
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  border: 1px solid transparent;
}

.nova-reserva-confirm-btn--secondary {
  background: #fff;
  color: #4b5563;
  border-color: #d1d5db;
}

.nova-reserva-confirm-btn--secondary:hover {
  background: #f3f4f6;
}

.nova-reserva-confirm-btn--danger {
  background: #dc2626;
  color: #fff;
  border-color: #dc2626;
}

.nova-reserva-confirm-btn--danger:hover {
  background: #b91c1c;
}

@media (max-width: 1024px) {
  .nova-reserva-grid {
    grid-template-columns: 1fr;
  }

  .nova-reserva-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .nova-reserva-page {
    padding: 16px 12px;
    gap: 16px;
  }

  .nova-reserva-grid {
    gap: 16px;
  }

  .nova-reserva-column {
    gap: 16px;
  }
}
</style>
