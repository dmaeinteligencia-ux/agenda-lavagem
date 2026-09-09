<template>
  <div class="jornada-lavador-form">
    <div class="jornada-lavador-form-field">
      <label for="regime" class="jornada-lavador-form-label">Regime</label>
      <select
        id="regime"
        v-model="formData.regime"
        class="jornada-lavador-form-select"
        :class="{ 'p-invalid': submitted && !formData.regime }"
        :disabled="mode === 'edit'"
      >
        <option value="">Selecione o regime</option>
        <option value="NORMAL">NORMAL</option>
        <option value="PLANTAO">PLANTAO</option>
      </select>
      <small v-if="submitted && !formData.regime" class="p-error">Regime é obrigatório</small>
    </div>

    <div class="jornada-lavador-form-field">
      <label for="horas" class="jornada-lavador-form-label">Horas Disponíveis</label>
      <input
        id="horas"
        type="number"
        v-model.number="formData.horas_disponiveis"
        :min="0.5"
        :step="0.5"
        :max="24"
        placeholder="0.0"
        class="jornada-lavador-form-input"
        :class="{ 'p-invalid': submitted && !formData.horas_disponiveis }"
      />
      <small v-if="submitted && !formData.horas_disponiveis" class="p-error">Horas disponíveis é obrigatório</small>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import type { JornadaLavador } from '@/utils/jornadaLavadorMock'

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

.jornada-lavador-form-select,
.jornada-lavador-form-input {
  width: 100%;
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

.jornada-lavador-form-select:focus,
.jornada-lavador-form-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.jornada-lavador-form-select:disabled {
  background: #f3f4f6;
  color: #6b7280;
}

.p-invalid {
  border-color: #ef4444 !important;
}

.p-error {
  color: #ef4444;
  font-size: 12px;
  margin-top: 4px;
  display: block;
}
</style>