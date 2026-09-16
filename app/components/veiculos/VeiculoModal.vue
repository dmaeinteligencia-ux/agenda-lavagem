<template>
  <div class="veiculo-modal-overlay" role="presentation">
    <div
      class="veiculo-modal"
      role="dialog"
      aria-modal="true"
      :aria-labelledby="`veiculo-modal-title-${mode}`"
    >
      <header class="veiculo-modal-header">
        <div class="veiculo-modal-header-text">
          <h2 :id="`veiculo-modal-title-${mode}`" class="veiculo-modal-title">
            {{ titulo }}
          </h2>
          <p class="veiculo-modal-subtitle">{{ subtitulo }}</p>
        </div>
        <button
          type="button"
          class="veiculo-modal-close"
          aria-label="Fechar"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="veiculo-modal-body">
        <VeiculoForm :form="form" :tipos="tipos" :readonly="readonly" />

        <p v-if="error" class="veiculo-modal-error" role="alert">{{ error }}</p>
      </div>

      <footer class="veiculo-modal-footer">
        <button
          v-if="readonly"
          type="button"
          class="veiculo-modal-btn veiculo-modal-btn--secondary"
          @click="$emit('close')"
        >
          Fechar
        </button>

        <template v-else>
          <button
            type="button"
            class="veiculo-modal-btn veiculo-modal-btn--secondary"
            :disabled="saving"
            @click="$emit('close')"
          >
            Cancelar
          </button>
          <button
            type="button"
            class="veiculo-modal-btn veiculo-modal-btn--primary"
            :disabled="saving"
            @click="submit"
          >
            <span v-if="saving" class="veiculo-modal-spinner" aria-hidden="true" />
            <span>{{ saving ? 'Salvando...' : confirmLabel }}</span>
          </button>
        </template>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, computed } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import VeiculoForm from './VeiculoForm.vue'
import {
  formDataInicial,
  veiculoToFormData,
  type TipoVeiculo,
  type Veiculo,
  type VeiculoFormData
} from '@/utils/veiculos'

interface Props {
  mode?: 'create' | 'edit' | 'view'
  veiculo?: Veiculo | null
  tipos: TipoVeiculo[]
  saving?: boolean
  error?: string | null
}

const props = withDefaults(defineProps<Props>(), {
  mode: 'create',
  veiculo: null,
  saving: false,
  error: null
})

const emit = defineEmits<{
  close: []
  submit: [data: VeiculoFormData]
}>()

const readonly = computed(() => props.mode === 'view')

const titulo = computed(() => {
  if (props.mode === 'edit') return 'Editar Veículo'
  if (props.mode === 'view') return 'Detalhes do Veículo'
  return 'Novo Veículo'
})

const subtitulo = computed(() => {
  if (props.mode === 'edit') return 'Atualize as informações do veículo da frota.'
  if (props.mode === 'view') return 'Informações do veículo da frota.'
  return 'Cadastre as informações do veículo da frota.'
})

const confirmLabel = computed(() => (props.mode === 'edit' ? 'Salvar alterações' : 'Salvar'))

const form = reactive<VeiculoFormData>(
  props.veiculo ? veiculoToFormData(props.veiculo) : formDataInicial()
)

const submit = () => {
  if (props.saving || readonly.value) {
    return
  }
  emit('submit', { ...form })
}
</script>

<style scoped>
.veiculo-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.veiculo-modal {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 820px;
  max-height: calc(100vh - 32px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.veiculo-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 28px 20px;
  border-bottom: 1px solid #e5e7eb;
}

.veiculo-modal-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.veiculo-modal-title {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.veiculo-modal-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.veiculo-modal-close {
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

.veiculo-modal-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.veiculo-modal-close:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.veiculo-modal-close svg {
  width: 20px;
  height: 20px;
}

.veiculo-modal-body {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.veiculo-modal-error {
  margin: 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.veiculo-modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 28px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
  flex-wrap: wrap;
}

.veiculo-modal-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px 22px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.veiculo-modal-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.veiculo-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.veiculo-modal-btn--primary:hover:not(:disabled) {
  background-color: #003570;
  border-color: #003570;
}

.veiculo-modal-btn--primary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.35);
}

.veiculo-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.veiculo-modal-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.veiculo-modal-btn--secondary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
}

.veiculo-modal-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: veiculo-modal-spin 0.6s linear infinite;
}

@keyframes veiculo-modal-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 600px) {
  .veiculo-modal-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .veiculo-modal {
    max-height: 92vh;
  }

  .veiculo-modal-header {
    padding: 20px 20px 16px;
  }

  .veiculo-modal-title {
    font-size: 18px;
  }

  .veiculo-modal-body {
    padding: 20px;
  }

  .veiculo-modal-footer {
    padding: 14px 20px 16px;
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .veiculo-modal-btn {
    width: 100%;
  }
}
</style>
