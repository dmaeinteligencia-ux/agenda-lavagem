<template>
  <div class="solicitante-form">
    <div class="solicitante-form-field">
      <label for="solicitante-matricula" class="solicitante-form-label">Matrícula</label>
      <input
        id="solicitante-matricula"
        v-model="formData.matricula"
        type="text"
        placeholder="Digite a matrícula"
        class="solicitante-form-input"
        :class="{ 'solicitante-form-input--error': submitted && errors.matricula }"
      />
      <span v-if="submitted && errors.matricula" class="solicitante-form-error">{{ errors.matricula }}</span>
    </div>

    <div class="solicitante-form-field">
      <label for="solicitante-nome" class="solicitante-form-label">Nome</label>
      <input
        id="solicitante-nome"
        v-model="formData.nome"
        type="text"
        placeholder="Digite o nome completo"
        class="solicitante-form-input"
        :class="{ 'solicitante-form-input--error': submitted && errors.nome }"
      />
      <span v-if="submitted && errors.nome" class="solicitante-form-error">{{ errors.nome }}</span>
    </div>

    <div class="solicitante-form-field">
      <label for="solicitante-telefone" class="solicitante-form-label">Telefone</label>
      <input
        id="solicitante-telefone"
        v-model="formData.telefone"
        type="text"
        placeholder="(34) 99999-9999"
        class="solicitante-form-input"
        :class="{ 'solicitante-form-input--error': submitted && errors.telefone }"
      />
      <span v-if="submitted && errors.telefone" class="solicitante-form-error">{{ errors.telefone }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, watch } from 'vue'
import type { Solicitante, SolicitanteFormData } from '@/utils/solicitantes'

interface Props {
  initialData?: Solicitante | null
  mode?: 'create' | 'edit'
}

const props = withDefaults(defineProps<Props>(), {
  initialData: null,
  mode: 'create'
})

const emit = defineEmits<{
  'update:form-data': [value: SolicitanteFormData]
}>()

const formData = reactive<SolicitanteFormData>({
  matricula: '',
  nome: '',
  telefone: ''
})

const errors = reactive<{ matricula: string; nome: string; telefone: string }>({
  matricula: '',
  nome: '',
  telefone: ''
})

const submitted = ref(false)

watch(
  () => props.initialData,
  (data) => {
    if (data) {
      formData.matricula = data.matricula
      formData.nome = data.nome
      formData.telefone = data.telefone
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
  errors.matricula = formData.matricula.trim() ? '' : 'Matrícula é obrigatória.'
  errors.nome = formData.nome.trim() ? '' : 'Nome é obrigatório.'
  errors.telefone = formData.telefone.trim() ? '' : 'Telefone é obrigatório.'
  return !errors.matricula && !errors.nome && !errors.telefone
}

defineExpose({ validate })
</script>

<style scoped>
.solicitante-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.solicitante-form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.solicitante-form-label {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.solicitante-form-input {
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

.solicitante-form-input::placeholder {
  color: #9ca3af;
}

.solicitante-form-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.solicitante-form-input--error {
  border-color: #dc2626;
}

.solicitante-form-error {
  font-size: 12px;
  color: #dc2626;
}
</style>
