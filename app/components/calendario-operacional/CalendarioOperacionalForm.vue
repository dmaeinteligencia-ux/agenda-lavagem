<template>
  <div class="calendario-operacional-form">
    <div class="calendario-operacional-form-field">
      <label for="calendario-operacional-data" class="calendario-operacional-form-label">Data</label>
      <input
        id="calendario-operacional-data"
        v-model="formData.data"
        type="date"
        class="calendario-operacional-form-input"
        :class="{ 'calendario-operacional-form-input--error': submitted && errors.data }"
      />
      <span v-if="submitted && errors.data" class="calendario-operacional-form-error">{{ errors.data }}</span>
    </div>

    <div class="calendario-operacional-form-field">
      <label for="calendario-operacional-tipo" class="calendario-operacional-form-label">Tipo da configuração</label>
      <select
        id="calendario-operacional-tipo"
        v-model="formData.tipo_configuracao"
        class="calendario-operacional-form-select"
      >
        <option v-for="opcao in tipoOpcoes" :key="opcao.value" :value="opcao.value">
          {{ opcao.label }}
        </option>
      </select>
    </div>

    <div class="calendario-operacional-form-field">
      <label for="calendario-operacional-regime" class="calendario-operacional-form-label">Regime</label>
      <select
        id="calendario-operacional-regime"
        v-model="formData.regime"
        class="calendario-operacional-form-select"
      >
        <option v-for="opcao in regimeOpcoes" :key="opcao.value" :value="opcao.value">
          {{ opcao.label }}
        </option>
      </select>
      <p class="calendario-operacional-form-helper">
        Padrão do sistema: segunda a sexta NORMAL; sábados, domingos e feriados oficiais PLANTÃO.
      </p>
    </div>

    <div class="calendario-operacional-form-field">
      <label for="calendario-operacional-atendimento" class="calendario-operacional-form-label">Atendimento</label>
      <select
        id="calendario-operacional-atendimento"
        v-model="formData.ativo"
        class="calendario-operacional-form-select"
      >
        <option :value="true">Ativo</option>
        <option :value="false">Inativo (sem atendimento)</option>
      </select>
      <p class="calendario-operacional-form-helper">
        Descreve esta data específica. Inativo bloqueia novas reservas, sem alterar as existentes.
      </p>
    </div>

    <div class="calendario-operacional-form-field">
      <label for="calendario-operacional-observacao" class="calendario-operacional-form-label">Observação</label>
      <input
        id="calendario-operacional-observacao"
        v-model="formData.observacao"
        type="text"
        placeholder="Ex.: Feriado municipal, ponto facultativo, sem equipe..."
        class="calendario-operacional-form-input"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, watch } from 'vue'
import {
  REGIME_OPCOES,
  TIPO_CONFIGURACAO_OPCOES,
  type CalendarioConfiguracao,
  type CalendarioOperacionalFormData,
  type CalendarioOperacionalSugestao
} from '@/utils/calendarioOperacional'

interface Props {
  initialData?: CalendarioConfiguracao | null
  sugestao?: CalendarioOperacionalSugestao | null
  mode?: 'create' | 'edit'
}

const props = withDefaults(defineProps<Props>(), {
  initialData: null,
  sugestao: null,
  mode: 'create'
})

const emit = defineEmits<{
  'update:form-data': [value: CalendarioOperacionalFormData]
}>()

const regimeOpcoes = REGIME_OPCOES
const tipoOpcoes = TIPO_CONFIGURACAO_OPCOES

const formData = reactive<CalendarioOperacionalFormData>({
  data: '',
  regime: 'NORMAL',
  ativo: true,
  tipo_configuracao: 'OUTRO',
  observacao: ''
})

const errors = reactive<{ data: string }>({
  data: ''
})

const submitted = ref(false)

watch(
  () => props.initialData,
  (data) => {
    if (data) {
      formData.data = data.data
      formData.regime = data.regime
      formData.ativo = data.ativo
      formData.tipo_configuracao = data.tipo_configuracao
      formData.observacao = data.observacao ?? ''
    }
  },
  { immediate: true }
)

watch(
  () => props.sugestao,
  (sugestao) => {
    if (sugestao && !props.initialData) {
      formData.data = sugestao.data
      formData.regime = sugestao.regime
      formData.ativo = sugestao.ativo
      formData.tipo_configuracao = sugestao.tipo_configuracao
      formData.observacao = ''
    }
  },
  { immediate: true }
)

watch(
  formData,
  () => emit('update:form-data', { ...formData }),
  { deep: true }
)

const validate = (): boolean => {
  submitted.value = true
  errors.data = formData.data ? '' : 'Data é obrigatória.'
  return !errors.data
}

defineExpose({ validate })
</script>

<style scoped>
.calendario-operacional-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.calendario-operacional-form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.calendario-operacional-form-label {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.calendario-operacional-form-select,
.calendario-operacional-form-input {
  padding: 10px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 2px solid #d1d5db;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  font-family: inherit;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.calendario-operacional-form-select {
  width: 100%;
}

.calendario-operacional-form-input::placeholder {
  color: #9ca3af;
}

.calendario-operacional-form-select:focus,
.calendario-operacional-form-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.calendario-operacional-form-input--error {
  border-color: #dc2626;
}

.calendario-operacional-form-error {
  font-size: 12px;
  color: #dc2626;
}

.calendario-operacional-form-helper {
  font-size: 12px;
  color: #9ca3af;
  margin: 0;
}
</style>
