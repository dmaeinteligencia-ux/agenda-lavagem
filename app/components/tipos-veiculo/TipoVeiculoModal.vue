<template>
  <div class="tipos-veiculo-modal-overlay" role="presentation">
    <div
      class="tipos-veiculo-modal"
      role="dialog"
      aria-modal="true"
      :aria-labelledby="`tipos-veiculo-modal-title-${mode}`"
    >
      <header class="tipos-veiculo-modal-header">
        <div class="tipos-veiculo-modal-header-text">
          <h2 :id="`tipos-veiculo-modal-title-${mode}`" class="tipos-veiculo-modal-title">
            {{ mode === 'edit' ? 'Editar Tipo de Veículo' : 'Novo Tipo de Veículo' }}
          </h2>
          <p class="tipos-veiculo-modal-subtitle">
            {{
              mode === 'edit'
                ? 'Atualize as informações do tipo de veículo.'
                : 'Cadastre um tipo de veículo e defina o tempo estimado de lavagem.'
            }}
          </p>
        </div>
        <button
          type="button"
          class="tipos-veiculo-modal-close"
          aria-label="Fechar"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="tipos-veiculo-modal-body">
        <TipoVeiculoForm
          ref="formRef"
          :initial-data="tipo"
          :mode="mode"
          @update:form-data="formData = $event"
        />
        <p v-if="error" class="tipos-veiculo-modal-error" role="alert">{{ error }}</p>
      </div>

      <footer class="tipos-veiculo-modal-footer">
        <button
          type="button"
          class="tipos-veiculo-modal-btn tipos-veiculo-modal-btn--secondary"
          :disabled="loading"
          @click="$emit('close')"
        >
          Cancelar
        </button>
        <button
          type="button"
          class="tipos-veiculo-modal-btn tipos-veiculo-modal-btn--primary"
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
import TipoVeiculoForm from './TipoVeiculoForm.vue'
import type { TipoVeiculo, TipoVeiculoFormData } from '@/utils/tiposVeiculo'

interface Props {
  mode?: 'create' | 'edit'
  tipo?: TipoVeiculo | null
  loading?: boolean
  error?: string | null
}

withDefaults(defineProps<Props>(), {
  mode: 'create',
  tipo: null,
  loading: false,
  error: null
})

const emit = defineEmits<{
  close: []
  save: [data: TipoVeiculoFormData]
}>()

const formRef = ref<InstanceType<typeof TipoVeiculoForm>>()
const formData = ref<TipoVeiculoFormData>({ descricao: '', tempo_min: 0 })

const onSave = () => {
  if (formRef.value && formRef.value.validate()) {
    emit('save', { ...formData.value })
  }
}
</script>

<style scoped>
.tipos-veiculo-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.tipos-veiculo-modal {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 600px;
  max-height: calc(100vh - 32px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.tipos-veiculo-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 28px 20px;
  border-bottom: 1px solid #e5e7eb;
}

.tipos-veiculo-modal-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.tipos-veiculo-modal-title {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.tipos-veiculo-modal-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.tipos-veiculo-modal-close {
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

.tipos-veiculo-modal-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.tipos-veiculo-modal-close:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.tipos-veiculo-modal-close svg {
  width: 20px;
  height: 20px;
}

.tipos-veiculo-modal-body {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
}

.tipos-veiculo-modal-error {
  margin: 16px 0 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.tipos-veiculo-modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 28px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
  flex-wrap: wrap;
}

.tipos-veiculo-modal-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 22px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  border: 1px solid transparent;
  transition: background-color 0.2s, color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.tipos-veiculo-modal-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.tipos-veiculo-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border-color: #004790;
}

.tipos-veiculo-modal-btn--primary:hover:not(:disabled) {
  background-color: #003570;
  border-color: #003570;
}

.tipos-veiculo-modal-btn--primary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.35);
}

.tipos-veiculo-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border-color: #d1d5db;
}

.tipos-veiculo-modal-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.tipos-veiculo-modal-btn--secondary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
}

@media (max-width: 600px) {
  .tipos-veiculo-modal-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .tipos-veiculo-modal {
    max-width: 100%;
    max-height: 92vh;
  }

  .tipos-veiculo-modal-header {
    padding: 20px 20px 16px;
  }

  .tipos-veiculo-modal-title {
    font-size: 18px;
  }

  .tipos-veiculo-modal-body {
    padding: 20px;
  }

  .tipos-veiculo-modal-footer {
    padding: 14px 20px 16px;
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .tipos-veiculo-modal-btn {
    width: 100%;
  }
}
</style>
