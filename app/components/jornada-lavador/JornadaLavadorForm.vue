<template>
  <div class="jornada-lavador-form">
    <div class="jornada-lavador-form-field">
      <label for="regime" class="jornada-lavador-form-label">Regime</label>
      <Dropdown
        id="regime"
        v-model="formData.regime"
        :options="regimeOptions"
        optionLabel="label"
        optionValue="value"
        placeholder="Selecione o regime"
        :disabled="mode === 'edit'"
        class="jornada-lavador-form-dropdown"
        :class="{ 'p-invalid': submitted && !formData.regime }"
      />
      <small v-if="submitted && !formData.regime" class="p-error">Regime é obrigatório</small>
    </div>

    <div class="jornada-lavador-form-field">
      <label for="horas" class="jornada-lavador-form-label">Horas Disponíveis</label>
      <InputNumber
        id="horas"
        v-model="formData.horas_disponiveis"
        :min="0.5"
        :step="0.5"
        placeholder="0.0"
        class="jornada-lavador-form-input"
        :class="{ 'p-invalid': submitted && !formData.horas_disponiveis }"
      />
      <small v-if="submitted && !formData.horas_disponiveis" class="p-error">Horas disponíveis é obrigatório</small>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { Dropdown } from 'primevue/dropdown'
import { InputNumber } from 'primevue/inputnumber'
import type { JornadaLavador } from '@/utils/jornadaLavadorMock'

interface RegimeOption {
  label: string
  value: 'NORMAL' | 'PLANTAO'
}

const regimeOptions: RegimeOption[] = [
  { label: 'NORMAL', value: 'NORMAL' },
  { label: 'PLANTAO', value: 'PLANTAO' }
]

interface Props {
  initialData?: JornadaLavador | null
  mode?: 'create' | 'edit'
}

const props = withDefaults(defineProps<Props>(), {
  initialData: null,
  mode: 'create'
})

const submitted = ref(false)
const formData = ref({
  regime: undefined as 'NORMAL' | 'PLANTAO' | undefined,
  horas_disponiveis: undefined as number | undefined
})

watch(() => props.initialData, (newData) => {
  if (newData) {
    formData.value = {
      regime: newData.regime,
      horas_disponiveis: newData.horas_disponiveis
    }
  }
}, { immediate: true })

const emit = defineEmits(['update:formData', 'validate'])

const validate = () => {
  submitted.value = true
  const isValid = !!(formData.value.regime && formData.value.horas_disponiveis)
  emit('validate', isValid)
  if (isValid) {
    emit('update:formData', { ...formData.value })
  }
}

defineExpose({ validate })
</script>

<style scoped>
.jornada-lavador-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  padding: 8px 0;
}

.jornada-lavador-form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.jornada-lavador-form-label {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.jornada-lavador-form-dropdown,
.jornada-lavador-form-input {
  width: 100%;
}

.jornada-lavador-form-dropdown .p-select-label,
.jornada-lavador-form-input .p-inputnumber-input {
  min-height: 42px;
  font-size: 14px;
}

.p-error {
  color: #ef4444;
  font-size: 12px;
  margin-top: 4px;
}
</style>