<template>
  <div class="agenda-action-modal-overlay" role="presentation">
    <div class="agenda-action-modal" role="dialog" aria-modal="true" aria-labelledby="agenda-action-title">
      <header class="agenda-action-modal-header">
        <h3 id="agenda-action-title" class="agenda-action-modal-title">{{ titulo }}</h3>
        <button type="button" class="agenda-action-modal-close" aria-label="Fechar" @click="$emit('close')">
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="agenda-action-modal-body">
        <p class="agenda-action-modal-mensagem">{{ mensagem }}</p>

        <div v-if="veiculo || placa" class="agenda-action-modal-veiculo">
          <span v-if="veiculo" class="agenda-action-modal-veiculo-nome">{{ veiculo }}</span>
          <span v-if="placa" class="agenda-action-modal-veiculo-placa">{{ placa }}</span>
        </div>

        <div v-if="motivos && motivos.length > 0" class="agenda-action-modal-campo">
          <label class="agenda-action-modal-label" for="agenda-action-motivo">Motivo</label>
          <select id="agenda-action-motivo" v-model="motivo" class="agenda-action-modal-select">
            <option value="" disabled>Selecione um motivo</option>
            <option v-for="m in motivos" :key="m.value" :value="m.value">{{ m.label }}</option>
          </select>
        </div>

        <div class="agenda-action-modal-campo">
          <label class="agenda-action-modal-label" for="agenda-action-observacao">Observação (opcional)</label>
          <textarea
            id="agenda-action-observacao"
            v-model="observacao"
            class="agenda-action-modal-textarea"
            rows="3"
            placeholder="Adicione uma observação, se necessário"
          />
        </div>

        <p v-if="localError || error" class="agenda-action-modal-error" role="alert">{{ localError || error }}</p>
      </div>

      <footer class="agenda-action-modal-footer">
        <button type="button" class="agenda-action-modal-btn agenda-action-modal-btn--secondary" :disabled="loading" @click="$emit('close')">
          Cancelar
        </button>
        <button
          type="button"
          class="agenda-action-modal-btn"
          :class="confirmClass"
          :disabled="loading"
          @click="submit"
        >
          <span v-if="loading" class="agenda-action-spinner" aria-hidden="true" />
          <span>{{ loading ? 'Processando...' : confirmLabel }}</span>
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import type { MotivoOpcao } from '@/utils/reservas'

interface Props {
  titulo: string
  mensagem: string
  veiculo: string | null
  placa: string | null
  confirmLabel: string
  variante?: 'default' | 'danger'
  loading: boolean
  error: string | null
  motivos?: MotivoOpcao[]
}

const props = withDefaults(defineProps<Props>(), {
  variante: 'default',
  motivos: undefined
})

const emit = defineEmits<{
  confirm: [payload: { motivo: string | null; observacao: string }]
  close: []
}>()

const observacao = ref('')
const motivo = ref('')
const localError = ref<string | null>(null)

const confirmClass = computed(() => {
  return props.variante === 'danger'
    ? 'agenda-action-modal-btn--danger'
    : 'agenda-action-modal-btn--primary'
})

const submit = () => {
  localError.value = null

  if (props.motivos && props.motivos.length > 0) {
    if (!motivo.value) {
      localError.value = 'Selecione um motivo.'
      return
    }
    if (motivo.value === 'OUTRO' && !observacao.value.trim()) {
      localError.value = 'Informe a observação para o motivo Outro.'
      return
    }
  }

  emit('confirm', { motivo: motivo.value || null, observacao: observacao.value })
}
</script>

<style scoped>
.agenda-action-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.agenda-action-modal {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 460px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  max-height: calc(100vh - 32px);
}

.agenda-action-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 20px 24px 16px;
  border-bottom: 1px solid #e5e7eb;
}

.agenda-action-modal-title {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #111827;
}

.agenda-action-modal-close {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border: none;
  background: transparent;
  border-radius: 8px;
  color: #6b7280;
  cursor: pointer;
}

.agenda-action-modal-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.agenda-action-modal-close svg {
  width: 20px;
  height: 20px;
}

.agenda-action-modal-body {
  padding: 20px 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  overflow-y: auto;
}

.agenda-action-modal-mensagem {
  margin: 0;
  font-size: 14px;
  color: #374151;
}

.agenda-action-modal-veiculo {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.agenda-action-modal-veiculo-nome {
  font-weight: 600;
  color: #111827;
  font-size: 14px;
}

.agenda-action-modal-veiculo-placa {
  font-size: 12px;
  font-weight: 500;
  color: #6b7280;
  background: #f3f4f6;
  padding: 2px 8px;
  border-radius: 4px;
}

.agenda-action-modal-campo {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.agenda-action-modal-label {
  font-size: 13px;
  font-weight: 600;
  color: #374151;
}

.agenda-action-modal-select {
  padding: 10px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  font-family: inherit;
  cursor: pointer;
}

.agenda-action-modal-select:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}

.agenda-action-modal-textarea {
  width: 100%;
  padding: 10px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  font-family: inherit;
  resize: vertical;
  box-sizing: border-box;
}

.agenda-action-modal-textarea:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}

.agenda-action-modal-error {
  margin: 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.agenda-action-modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 24px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.agenda-action-modal-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  border: 1px solid transparent;
}

.agenda-action-modal-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.agenda-action-modal-btn--primary {
  background: #004790;
  color: #fff;
  border-color: #004790;
}

.agenda-action-modal-btn--primary:hover:not(:disabled) {
  background: #003570;
}

.agenda-action-modal-btn--danger {
  background: #dc2626;
  color: #fff;
  border-color: #dc2626;
}

.agenda-action-modal-btn--danger:hover:not(:disabled) {
  background: #b91c1c;
}

.agenda-action-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border-color: #d1d5db;
}

.agenda-action-modal-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.agenda-action-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: agenda-action-spin 0.6s linear infinite;
}

@keyframes agenda-action-spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
