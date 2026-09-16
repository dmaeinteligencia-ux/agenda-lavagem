<template>
  <div class="jornada-lavador-form">
    <div class="jornada-lavador-form-field">
      <label for="jornada-lavador-regime" class="jornada-lavador-form-label">Regime</label>
      <select
        id="jornada-lavador-regime"
        v-model="formData.regime"
        class="jornada-lavador-form-select"
        disabled
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
          v-model.number="formData.horas_disponiveis"
          type="number"
          :min="1"
          :step="1"
          class="jornada-lavador-form-input"
        />
        <span class="jornada-lavador-form-unidade">horas</span>
      </div>
      <p class="jornada-lavador-form-helper">
        Define a capacidade diária (minutos) deste regime na disponibilidade.
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, computed, watch } from 'vue'
import { diasPorRegime, type JornadaLavador, type JornadaLavadorFormData } from '@/utils/jornadaLavador'

interface Props {
  initialData?: JornadaLavador | null
}

const props = withDefaults(defineProps<Props>(), {
  initialData: null
})

const emit = defineEmits<{
  'update:form-data': [value: JornadaLavadorFormData]
}>()

const formData = reactive<JornadaLavadorFormData>({
  regime: 'NORMAL',
  horas_disponiveis: 8
})

watch(
  () => props.initialData,
  (data) => {
    if (data) {
      formData.regime = data.regime
      formData.horas_disponiveis = data.horas_disponiveis
    }
  },
  { immediate: true }
)

watch(
  formData,
  () => emit('update:form-data', { ...formData }),
  { deep: true }
)

const regimeHelper = computed(() => diasPorRegime(formData.regime))
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

.jornada-lavador-form-select:disabled {
  background: #f9fafb;
  color: #6b7280;
  cursor: not-allowed;
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
</style>
