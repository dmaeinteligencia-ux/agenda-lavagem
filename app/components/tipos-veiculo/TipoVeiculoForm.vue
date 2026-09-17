<template>
  <div class="tipos-veiculo-form">
    <div class="tipos-veiculo-form-field">
      <label class="tipos-veiculo-form-label" for="tipos-veiculo-desc">Tipo de veículo</label>
      <input
        id="tipos-veiculo-desc"
        v-model="formData.descricao"
        type="text"
        placeholder="Ex.: Caminhão"
        class="tipos-veiculo-form-input"
        :class="{ 'tipos-veiculo-form-input--error': submitted && errors.descricao }"
      />
      <span v-if="submitted && errors.descricao" class="tipos-veiculo-form-error">{{ errors.descricao }}</span>
    </div>

    <div class="tipos-veiculo-form-field">
      <label class="tipos-veiculo-form-label" for="tipos-veiculo-tempo">Tempo de lavagem</label>
      <div class="tipos-veiculo-form-tempo-wrapper">
        <input
          id="tipos-veiculo-tempo"
          v-model.number="formData.tempo_min"
          type="number"
          min="1"
          step="1"
          placeholder="90"
          class="tipos-veiculo-form-input"
          :class="{ 'tipos-veiculo-form-input--error': submitted && errors.tempo_min }"
        />
        <span class="tipos-veiculo-form-unidade">minutos</span>
      </div>
      <span v-if="submitted && errors.tempo_min" class="tipos-veiculo-form-error">{{ errors.tempo_min }}</span>
    </div>

    <p class="tipos-veiculo-form-auxilio">
      Informe o tempo estimado necessário para realizar a lavagem deste tipo de veículo.
    </p>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, watch } from 'vue'
import type { TipoVeiculo, TipoVeiculoFormData } from '@/utils/tiposVeiculo'

interface Props {
  initialData?: TipoVeiculo | null
  mode?: 'create' | 'edit'
}

const props = withDefaults(defineProps<Props>(), {
  initialData: null,
  mode: 'create'
})

const emit = defineEmits<{
  'update:form-data': [value: TipoVeiculoFormData]
}>()

const formData = reactive<TipoVeiculoFormData>({
  descricao: '',
  tempo_min: 0
})

const errors = reactive<{ descricao: string; tempo_min: string }>({
  descricao: '',
  tempo_min: ''
})

const submitted = ref(false)

watch(
  () => props.initialData,
  (data) => {
    if (data) {
      formData.descricao = data.descricao
      formData.tempo_min = data.tempo_min
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

  const descricao = formData.descricao.trim()
  const tempo = Number(formData.tempo_min)

  errors.descricao = descricao ? '' : 'Descrição é obrigatória.'
  errors.tempo_min =
    Number.isInteger(tempo) && tempo > 0
      ? ''
      : 'Informe um tempo válido em minutos (maior que 0).'

  return !errors.descricao && !errors.tempo_min
}

defineExpose({ validate })
</script>

<style scoped>
.tipos-veiculo-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.tipos-veiculo-form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.tipos-veiculo-form-label {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.tipos-veiculo-form-tempo-wrapper {
  display: flex;
  align-items: center;
}

.tipos-veiculo-form-input {
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
  width: 100%;
}

.tipos-veiculo-form-input::placeholder {
  color: #9ca3af;
}

.tipos-veiculo-form-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.tipos-veiculo-form-input--error {
  border-color: #dc2626;
}

.tipos-veiculo-form-error {
  font-size: 12px;
  color: #dc2626;
}

.tipos-veiculo-form-unidade {
  margin-left: 8px;
  font-size: 14px;
  color: #6b7280;
  flex-shrink: 0;
}

.tipos-veiculo-form-auxilio {
  font-size: 12px;
  color: #9ca3af;
  margin-top: 4px;
}
</style>
