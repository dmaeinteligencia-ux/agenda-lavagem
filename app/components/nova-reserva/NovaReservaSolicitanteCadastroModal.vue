<template>
  <div class="solicitante-cadastro-overlay" role="presentation">
    <div
      class="solicitante-cadastro"
      role="dialog"
      aria-modal="true"
      aria-labelledby="solicitante-cadastro-title"
    >
      <header class="solicitante-cadastro-header">
        <div class="solicitante-cadastro-header-text">
          <h3 id="solicitante-cadastro-title" class="solicitante-cadastro-title">
            Cadastrar como solicitante
          </h3>
          <p class="solicitante-cadastro-subtitle">
            Não encontramos esta matrícula. Preencha seus dados para continuar a reserva.
          </p>
        </div>
        <button
          type="button"
          class="solicitante-cadastro-close"
          aria-label="Fechar"
          :disabled="loading"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="solicitante-cadastro-body">
        <div class="solicitante-cadastro-field">
          <label class="solicitante-cadastro-label" for="solicitante-cadastro-nome">Nome</label>
          <input
            id="solicitante-cadastro-nome"
            v-model="nome"
            class="solicitante-cadastro-input"
            :class="{ 'solicitante-cadastro-input--error': submitted && errors.nome }"
            type="text"
            placeholder="Digite o nome completo"
            :disabled="loading"
          />
          <span v-if="submitted && errors.nome" class="solicitante-cadastro-error-msg">{{ errors.nome }}</span>
        </div>

        <div class="solicitante-cadastro-field">
          <label class="solicitante-cadastro-label" for="solicitante-cadastro-matricula">Matrícula</label>
          <input
            id="solicitante-cadastro-matricula"
            class="solicitante-cadastro-input solicitante-cadastro-input--readonly"
            type="text"
            :value="matricula"
            readonly
            aria-readonly="true"
          />
        </div>

        <div class="solicitante-cadastro-field">
          <label class="solicitante-cadastro-label" for="solicitante-cadastro-telefone">Telefone</label>
          <input
            id="solicitante-cadastro-telefone"
            v-model="telefone"
            class="solicitante-cadastro-input"
            :class="{ 'solicitante-cadastro-input--error': submitted && errors.telefone }"
            type="text"
            placeholder="(34) 99999-9999"
            :disabled="loading"
          />
          <span v-if="submitted && errors.telefone" class="solicitante-cadastro-error-msg">{{ errors.telefone }}</span>
        </div>

        <p v-if="error" class="solicitante-cadastro-erro" role="alert">{{ error }}</p>
      </div>

      <footer class="solicitante-cadastro-footer">
        <button
          type="button"
          class="solicitante-cadastro-btn solicitante-cadastro-btn--secondary"
          :disabled="loading"
          @click="$emit('close')"
        >
          Cancelar
        </button>
        <button
          type="button"
          class="solicitante-cadastro-btn solicitante-cadastro-btn--primary"
          :disabled="loading"
          :aria-busy="loading"
          @click="salvar"
        >
          <span v-if="loading" class="solicitante-cadastro-spinner" aria-hidden="true" />
          {{ loading ? 'Cadastrando...' : 'Salvar' }}
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'

interface Props {
  matricula: string
  loading: boolean
  error: string | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
  close: []
  salvar: [data: { nome: string; matricula: string; telefone: string }]
}>()

const nome = ref('')
const telefone = ref('')
const submitted = ref(false)

const errors = reactive<{ nome: string; telefone: string }>({
  nome: '',
  telefone: ''
})

const salvar = () => {
  submitted.value = true

  errors.nome = nome.value.trim() ? '' : 'Nome é obrigatório.'
  errors.telefone = telefone.value.trim() ? '' : 'Telefone é obrigatório.'

  if (errors.nome || errors.telefone) {
    return
  }

  emit('salvar', {
    nome: nome.value.trim(),
    matricula: props.matricula.trim(),
    telefone: telefone.value.trim()
  })
}
</script>

<style scoped>
.solicitante-cadastro-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.solicitante-cadastro {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 480px;
  max-height: calc(100vh - 32px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.solicitante-cadastro-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 24px 20px;
  border-bottom: 1px solid #e5e7eb;
}

.solicitante-cadastro-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.solicitante-cadastro-title {
  font-size: 18px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.solicitante-cadastro-subtitle {
  font-size: 13px;
  color: #6b7280;
  margin: 0;
}

.solicitante-cadastro-close {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border: none;
  background: transparent;
  border-radius: 8px;
  color: #6b7280;
  cursor: pointer;
  flex-shrink: 0;
}

.solicitante-cadastro-close:hover:not(:disabled) {
  background: #f3f4f6;
  color: #111827;
}

.solicitante-cadastro-close:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.solicitante-cadastro-close svg {
  width: 20px;
  height: 20px;
}

.solicitante-cadastro-body {
  padding: 24px;
  overflow-y: auto;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.solicitante-cadastro-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.solicitante-cadastro-label {
  font-size: 13px;
  font-weight: 600;
  color: #374151;
}

.solicitante-cadastro-input {
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

.solicitante-cadastro-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.solicitante-cadastro-input--readonly {
  background: #f3f4f6;
  color: #6b7280;
  cursor: not-allowed;
}

.solicitante-cadastro-input--error {
  border-color: #dc2626;
}

.solicitante-cadastro-error-msg {
  font-size: 12px;
  color: #dc2626;
}

.solicitante-cadastro-erro {
  margin: 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.solicitante-cadastro-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 24px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.solicitante-cadastro-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  border: 1px solid transparent;
  transition: background-color 0.2s, border-color 0.2s, color 0.2s;
}

.solicitante-cadastro-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.solicitante-cadastro-btn--primary {
  background-color: #004790;
  color: #fff;
  border-color: #004790;
}

.solicitante-cadastro-btn--primary:hover:not(:disabled) {
  background-color: #003570;
  border-color: #003570;
}

.solicitante-cadastro-btn--primary:focus-visible,
.solicitante-cadastro-btn--secondary:focus-visible,
.solicitante-cadastro-close:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.solicitante-cadastro-btn--secondary {
  background: #fff;
  color: #4b5563;
  border-color: #d1d5db;
}

.solicitante-cadastro-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.solicitante-cadastro-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: solicitante-cadastro-spin 0.6s linear infinite;
}

@keyframes solicitante-cadastro-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 600px) {
  .solicitante-cadastro-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .solicitante-cadastro {
    max-width: 100%;
    max-height: 92vh;
  }

  .solicitante-cadastro-header {
    padding: 20px 20px 16px;
  }

  .solicitante-cadastro-body {
    padding: 20px;
  }

  .solicitante-cadastro-footer {
    padding: 14px 20px 16px;
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .solicitante-cadastro-btn {
    width: 100%;
  }
}
</style>
