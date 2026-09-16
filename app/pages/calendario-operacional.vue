<template>
  <div class="calendario-operacional-page">
    <CalendarioOperacionalPageHeader @new-configuracao="openCreate" />
    <CalendarioOperacionalSummary :summary="summary" />

    <div
      v-if="feedback"
      class="calendario-operacional-feedback"
      :class="`calendario-operacional-feedback--${feedback.type}`"
      role="status"
    >
      <span>{{ feedback.message }}</span>
      <button type="button" class="calendario-operacional-feedback-close" aria-label="Fechar" @click="feedback = null">
        <XMarkIcon aria-hidden="true" />
      </button>
    </div>

    <div v-if="loading" class="calendario-operacional-state">
      <span class="calendario-operacional-spinner" aria-hidden="true" />
      <span>Carregando calendário operacional...</span>
    </div>

    <div v-else-if="error" class="calendario-operacional-state calendario-operacional-state--erro" role="alert">
      <p class="calendario-operacional-state-message">{{ error }}</p>
      <button type="button" class="calendario-operacional-retry" @click="carregar">Tentar novamente</button>
    </div>

    <CalendarioOperacionalCalendar
      v-else
      :ano="ano"
      :mes="mes"
      :configuracoes="configuracoes"
      :feriados="feriados"
      @change-month="handleChangeMonth"
      @select-day="handleSelectDay"
    />

    <CalendarioOperacionalModal
      v-if="showModal"
      :mode="modalMode"
      :configuracao="configuracaoEdicao"
      :sugestao="sugestao"
      :loading="saving"
      :error="modalError"
      @close="closeModal"
      @save="handleSave"
      @remove="handleRemove"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import CalendarioOperacionalPageHeader from '@/components/calendario-operacional/CalendarioOperacionalPageHeader.vue'
import CalendarioOperacionalSummary from '@/components/calendario-operacional/CalendarioOperacionalSummary.vue'
import CalendarioOperacionalCalendar from '@/components/calendario-operacional/CalendarioOperacionalCalendar.vue'
import CalendarioOperacionalModal from '@/components/calendario-operacional/CalendarioOperacionalModal.vue'
import { useCalendarioOperacional } from '@/composables/useCalendarioOperacional'
import {
  resumoDoMes,
  type CalendarioConfiguracao,
  type CalendarioOperacionalFormData,
  type CalendarioOperacionalSugestao,
  type DiaOperacional
} from '@/utils/calendarioOperacional'

definePageMeta({
  layout: 'default'
})

const {
  configuracoes,
  feriados,
  loading,
  error,
  saving,
  carregarMes,
  criarConfiguracao,
  atualizarConfiguracao,
  restaurarPadrao
} = useCalendarioOperacional()

const hoje = new Date()
const ano = ref(hoje.getFullYear())
const mes = ref(hoje.getMonth())

const showModal = ref(false)
const modalMode = ref<'create' | 'edit'>('create')
const configuracaoEdicao = ref<CalendarioConfiguracao | null>(null)
const sugestao = ref<CalendarioOperacionalSugestao | null>(null)
const modalError = ref<string | null>(null)
const feedback = ref<{ type: 'success' | 'error'; message: string } | null>(null)

const summary = computed(() => resumoDoMes(configuracoes.value))

const carregar = () => carregarMes(ano.value, mes.value)

watch([ano, mes], carregar)

const handleChangeMonth = (payload: { ano: number; mes: number }) => {
  ano.value = payload.ano
  mes.value = payload.mes
}

const openCreate = () => {
  modalMode.value = 'create'
  configuracaoEdicao.value = null
  sugestao.value = {
    data: '',
    regime: 'NORMAL',
    ativo: true,
    tipo_configuracao: 'OUTRO'
  }
  modalError.value = null
  showModal.value = true
}

const handleSelectDay = (payload: { data: string; resolvido: DiaOperacional }) => {
  modalError.value = null

  if (payload.resolvido.configuracao) {
    modalMode.value = 'edit'
    configuracaoEdicao.value = { ...payload.resolvido.configuracao }
    sugestao.value = null
  } else {
    modalMode.value = 'create'
    configuracaoEdicao.value = null
    sugestao.value = {
      data: payload.data,
      regime: payload.resolvido.regime,
      ativo: payload.resolvido.ativo,
      tipo_configuracao: 'OUTRO'
    }
  }

  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  modalError.value = null
}

const handleSave = async (data: CalendarioOperacionalFormData) => {
  modalError.value = null

  const editando = modalMode.value === 'edit' && configuracaoEdicao.value !== null
  const resultado = editando && configuracaoEdicao.value
    ? await atualizarConfiguracao(configuracaoEdicao.value.id, data)
    : await criarConfiguracao(data)

  if (!resultado.success) {
    modalError.value = resultado.error
    return
  }

  showModal.value = false
  feedback.value = {
    type: 'success',
    message: editando ? 'Configuração atualizada com sucesso.' : 'Configuração criada com sucesso.'
  }
  await carregar()
}

const handleRemove = async () => {
  if (!configuracaoEdicao.value) {
    return
  }

  modalError.value = null
  const resultado = await restaurarPadrao(configuracaoEdicao.value.id)

  if (!resultado.success) {
    modalError.value = resultado.error
    return
  }

  showModal.value = false
  feedback.value = { type: 'success', message: 'Padrão restaurado com sucesso.' }
  await carregar()
}

onMounted(carregar)
</script>

<style scoped>
.calendario-operacional-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.calendario-operacional-feedback {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 14px;
}

.calendario-operacional-feedback--success {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.calendario-operacional-feedback--error {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.calendario-operacional-feedback-close {
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

.calendario-operacional-feedback-close:hover {
  background: rgba(0, 0, 0, 0.06);
}

.calendario-operacional-feedback-close svg {
  width: 16px;
  height: 16px;
}

.calendario-operacional-state {
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

.calendario-operacional-state--erro {
  color: #4b5563;
}

.calendario-operacional-state-message {
  margin: 0;
}

.calendario-operacional-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: calendario-operacional-spin 0.8s linear infinite;
}

@keyframes calendario-operacional-spin {
  to {
    transform: rotate(360deg);
  }
}

.calendario-operacional-retry {
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

.calendario-operacional-retry:hover {
  background: #e8f0fe;
}

@media (max-width: 1024px) {
  .calendario-operacional-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .calendario-operacional-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>
