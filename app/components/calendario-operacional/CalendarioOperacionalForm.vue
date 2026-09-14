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
      <label for="calendario-operacional-regime" class="calendario-operacional-form-label">Regime</label>
      <select
        id="calendario-operacional-regime"
        v-model="formData.regime"
        class="calendario-operacional-form-select"
      >
        <option value="NORMAL">NORMAL</option>
        <option value="PLANTAO">PLANTÃO</option>
      </select>
      <p class="calendario-operacional-form-helper">
        Segunda a sexta-feira: NORMAL. Sábados, domingos e feriados: PLANTÃO.
      </p>
    </div>

    <div class="calendario-operacional-form-field">
      <label for="calendario-operacional-observacao" class="calendario-operacional-form-label">Observação</label>
      <input
        id="calendario-operacional-observacao"
        v-model="formData.observacao"
        type="text"
        placeholder="Ex.: Feriado municipal, expediente especial..."
        class="calendario-operacional-form-input"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, watch } from 'vue'
import type {
  CalendarioOperacionalMock,
  CalendarioOperacionalFormData,
  CalendarioOperacionalSugestao
} from '@/utils/calendarioOperacionalMock'

interface Props {
  initialData?: CalendarioOperacionalMock | null
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

const formData = reactive<CalendarioOperacionalFormData>({
  data: '',
  regime: 'NORMAL',
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
      formData.observacao = data.observacao
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
