<template>
  <div class="jornada-lavador-form">
    <div class="jornada-lavador-form-field">
      <label for="jornada-lavador-regime" class="jornada-lavador-form-label">Regime</label>
      <select
        id="jornada-lavador-regime"
        v-model="formData.regime"
        class="jornada-lavador-form-select"
      >
        <option value="NORMAL">NORMAL</option>
        <option value="PLANTAO">PLANTÃO</option>
      </select>
      <p class="jornada-lavador-form-helper">{{ regimeHelper }}</p>
    </div>

    <div class="jornada-lavador-form-field">
      <label for="jornada-lavador-horas" class="jornada-lavador-form-label">Horas disponíveis</label>
      <div class="jornada-lavador-form-horas-wrapper">
        <input
          id="jornada-lavador-horas"
          v-model.number="formData.horas"
          type="number"
          :min="0.5"
          :step="0.5"
          :max="maxHoras"
          class="jornada-lavador-form-input"
        />
        <span class="jornada-lavador-form-unidade">horas</span>
      </div>
      <p class="jornada-lavador-form-helper">{{ horasHelper }}</p>
    </div>

    <div class="jornada-lavador-form-field">
      <div class="jornada-lavador-form-toggle-row">
        <div class="jornada-lavador-form-toggle-text">
          <span class="jornada-lavador-form-label jornada-lavador-form-label--inline">Disponível para agendamento</span>
          <span class="jornada-lavador-form-toggle-state">{{ formData.disponivel_agendamento ? 'Sim' : 'Não' }}</span>
        </div>
        <button
          type="button"
          role="switch"
          :aria-checked="formData.disponivel_agendamento"
          class="jornada-lavador-form-switch"
          :class="{ 'jornada-lavador-form-switch--on': formData.disponivel_agendamento }"
          @click="formData.disponivel_agendamento = !formData.disponivel_agendamento"
        >
          <span class="jornada-lavador-form-switch-thumb" />
        </button>
      </div>
      <p class="jornada-lavador-form-helper">
        O regime PLANTÃO pode permanecer cadastrado e indisponível para agendamento.
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, computed, watch } from 'vue'
import type { JornadaLavadorMock, JornadaLavadorFormData } from '@/utils/jornadaLavadorMock'

interface Props {
  initialData?: JornadaLavadorMock | null
  mode?: 'create' | 'edit'
}

const props = withDefaults(defineProps<Props>(), {
  initialData: null,
  mode: 'create'
})

const emit = defineEmits<{
  'update:form-data': [value: JornadaLavadorFormData]
}>()

const formData = reactive<JornadaLavadorFormData>({
  regime: 'NORMAL',
  horas: 8,
  disponivel_agendamento: true
})

watch(
  () => props.initialData,
  (data) => {
    if (data) {
      formData.regime = data.regime
      formData.horas = data.horas
      formData.disponivel_agendamento = data.disponivel_agendamento
    }
  },
  { immediate: true }
)

watch(
  formData,
  () => emit('update:form-data', { ...formData }),
  { deep: true }
)

const maxHoras = computed(() => (formData.regime === 'NORMAL' ? 8 : 24))

const regimeHelper = computed(() =>
  formData.regime === 'NORMAL'
    ? 'Aplica-se de segunda a sexta-feira.'
    : 'Aplica-se aos sábados, domingos e feriados.'
)

const horasHelper = computed(() =>
  formData.regime === 'NORMAL'
    ? 'O regime NORMAL permite até 8 horas por dia.'
    : 'Informe a jornada em horas para o regime PLANTÃO.'
)
</script>

<style scoped>
.jornada-lavador-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
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

.jornada-lavador-form-label--inline {
  display: block;
}

.jornada-lavador-form-select,
.jornada-lavador-form-input {
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

.jornada-lavador-form-select {
  width: 100%;
}

.jornada-lavador-form-horas-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
}

.jornada-lavador-form-input {
  width: 120px;
}

.jornada-lavador-form-unidade {
  font-size: 14px;
  color: #6b7280;
}

.jornada-lavador-form-helper {
  font-size: 12px;
  color: #9ca3af;
  margin: 0;
}

.jornada-lavador-form-toggle-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.jornada-lavador-form-toggle-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0;
}

.jornada-lavador-form-toggle-state {
  font-size: 13px;
  font-weight: 600;
  color: #004790;
}

.jornada-lavador-form-switch {
  position: relative;
  width: 44px;
  height: 24px;
  border-radius: 999px;
  background: #d1d5db;
  border: none;
  cursor: pointer;
  transition: background 0.2s;
  flex-shrink: 0;
}

.jornada-lavador-form-switch--on {
  background: #004790;
}

.jornada-lavador-form-switch:focus-visible {
  outline: 2px solid #004790;
  outline-offset: 2px;
}

.jornada-lavador-form-switch-thumb {
  position: absolute;
  top: 2px;
  left: 2px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
  transition: transform 0.2s;
}

.jornada-lavador-form-switch--on .jornada-lavador-form-switch-thumb {
  transform: translateX(20px);
}
</style>
