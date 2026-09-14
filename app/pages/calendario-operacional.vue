<template>
  <div class="calendario-operacional-page">
    <CalendarioOperacionalPageHeader @new-configuracao="openCreate" />
    <CalendarioOperacionalSummary :summary="summary" />
    <CalendarioOperacionalFilters v-model="regimeFilter" />
    <CalendarioOperacionalCalendar
      :configuracoes="configuracoesVisiveis"
      @select-day="handleSelectDay"
    />

    <CalendarioOperacionalModal
      v-if="showModal"
      :mode="modalMode"
      :configuracao="configuracaoEdicao"
      :sugestao="sugestao"
      @close="closeModal"
      @save="handleSave"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import CalendarioOperacionalPageHeader from '@/components/calendario-operacional/CalendarioOperacionalPageHeader.vue'
import CalendarioOperacionalSummary from '@/components/calendario-operacional/CalendarioOperacionalSummary.vue'
import CalendarioOperacionalFilters from '@/components/calendario-operacional/CalendarioOperacionalFilters.vue'
import CalendarioOperacionalCalendar from '@/components/calendario-operacional/CalendarioOperacionalCalendar.vue'
import CalendarioOperacionalModal from '@/components/calendario-operacional/CalendarioOperacionalModal.vue'
import { configuracoesCalendarioMock, getRegimePadrao } from '@/utils/calendarioOperacionalMock'
import type {
  CalendarioOperacionalMock,
  CalendarioOperacionalFormData,
  CalendarioOperacionalSugestao
} from '@/utils/calendarioOperacionalMock'

definePageMeta({
  layout: 'default'
})

const configuracoes = ref<CalendarioOperacionalMock[]>([...configuracoesCalendarioMock])
const regimeFilter = ref('')
const showModal = ref(false)
const modalMode = ref<'create' | 'edit'>('create')
const configuracaoEdicao = ref<CalendarioOperacionalMock | null>(null)
const sugestao = ref<CalendarioOperacionalSugestao | null>(null)

const summary = computed(() => ({
  total: String(configuracoes.value.length),
  normal: String(configuracoes.value.filter((c) => c.regime === 'NORMAL').length),
  plantao: String(configuracoes.value.filter((c) => c.regime === 'PLANTAO').length)
}))

const configuracoesVisiveis = computed(() => {
  if (!regimeFilter.value) {
    return configuracoes.value
  }
  return configuracoes.value.filter((c) => c.regime === regimeFilter.value)
})

const openCreate = () => {
  modalMode.value = 'create'
  configuracaoEdicao.value = null
  sugestao.value = null
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const handleSelectDay = (payload: { data: string; config: CalendarioOperacionalMock | null }) => {
  if (payload.config) {
    modalMode.value = 'edit'
    configuracaoEdicao.value = { ...payload.config }
    sugestao.value = null
  } else {
    modalMode.value = 'create'
    configuracaoEdicao.value = null
    sugestao.value = { data: payload.data, regime: getRegimePadrao(payload.data) }
  }
  showModal.value = true
}

const handleSave = (data: CalendarioOperacionalFormData) => {
  if (modalMode.value === 'edit' && configuracaoEdicao.value) {
    const index = configuracoes.value.findIndex((c) => c.id === configuracaoEdicao.value?.id)
    if (index !== -1) {
      configuracoes.value[index] = {
        ...configuracoes.value[index],
        ...data
      }
    }
  } else {
    configuracoes.value.push({
      id: String(Date.now()),
      ...data
    })
  }
  showModal.value = false
}
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
