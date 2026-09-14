<template>
  <div class="solicitante-modal-overlay" role="presentation">
    <div
      class="solicitante-modal"
      role="dialog"
      aria-modal="true"
      :aria-labelledby="`solicitante-modal-title-${mode}`"
    >
      <header class="solicitante-modal-header">
        <div class="solicitante-modal-header-text">
          <h2 :id="`solicitante-modal-title-${mode}`" class="solicitante-modal-title">
            {{ mode === 'edit' ? 'Editar Solicitante' : 'Novo Solicitante' }}
          </h2>
          <p class="solicitante-modal-subtitle">
            {{ mode === 'edit' ? 'Atualize os dados do solicitante.' : 'Cadastre um solicitante autorizado a reservar lavagens.' }}
          </p>
        </div>
        <button
          type="button"
          class="solicitante-modal-close"
          aria-label="Fechar"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="solicitante-modal-body">
        <SolicitanteForm
          ref="formRef"
          :initial-data="solicitante"
          :mode="mode"
          @update:form-data="formData = $event"
        />
        <p v-if="error" class="solicitante-modal-error" role="alert">{{ error }}</p>
      </div>

      <footer class="solicitante-modal-footer">
        <button
          type="button"
          class="solicitante-modal-btn solicitante-modal-btn--secondary"
          :disabled="loading"
          @click="$emit('close')"
        >
          Cancelar
        </button>
        <button
          type="button"
          class="solicitante-modal-btn solicitante-modal-btn--primary"
          :disabled="loading"
          @click="onSave"
        >
          {{ loading ? 'Salvando...' : mode === 'edit' ? 'Salvar alterações' : 'Salvar' }}
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import SolicitanteForm from './SolicitanteForm.vue'
import type { SolicitanteMock, SolicitanteFormData } from '@/utils/solicitantesMock'

interface Props {
  mode?: 'create' | 'edit'
  solicitante?: SolicitanteMock | null
  loading?: boolean
  error?: string | null
}

withDefaults(defineProps<Props>(), {
  mode: 'create',
  solicitante: null,
  loading: false,
  error: null
})

const emit = defineEmits<{
  close: []
  save: [data: SolicitanteFormData]
}>()

const formRef = ref<InstanceType<typeof SolicitanteForm>>()
const formData = ref<SolicitanteFormData>({
  matricula: '',
  nome: '',
  telefone: ''
})

const onSave = () => {
  if (formRef.value && formRef.value.validate()) {
    emit('save', { ...formData.value })
  }
}
</script>

<style scoped>
.solicitante-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.solicitante-modal {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 560px;
  max-height: calc(100vh - 32px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.solicitante-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 28px 20px;
  border-bottom: 1px solid #e5e7eb;
}

.solicitante-modal-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.solicitante-modal-title {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.solicitante-modal-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.solicitante-modal-close {
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
  transition: background-color 0.15s, color 0.15s;
  flex-shrink: 0;
}

.solicitante-modal-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.solicitante-modal-close:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.solicitante-modal-close svg {
  width: 20px;
  height: 20px;
}

.solicitante-modal-body {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
}

.solicitante-modal-error {
  margin: 16px 0 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.solicitante-modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 28px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
  flex-wrap: wrap;
}

.solicitante-modal-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 22px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.solicitante-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.solicitante-modal-btn--primary:hover {
  background-color: #003570;
  border-color: #003570;
}

.solicitante-modal-btn--primary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.35);
}

.solicitante-modal-btn--primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.solicitante-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.solicitante-modal-btn--secondary:hover {
  background: #f3f4f6;
}

.solicitante-modal-btn--secondary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.solicitante-modal-btn--secondary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
}

@media (max-width: 600px) {
  .solicitante-modal-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .solicitante-modal {
    max-width: 100%;
    max-height: 92vh;
  }

  .solicitante-modal-header {
    padding: 20px 20px 16px;
  }

  .solicitante-modal-title {
    font-size: 18px;
  }

  .solicitante-modal-body {
    padding: 20px;
  }

  .solicitante-modal-footer {
    padding: 14px 20px 16px;
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .solicitante-modal-btn {
    width: 100%;
  }
}
</style>
