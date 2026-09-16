<template>
  <div class="veiculo-confirm-overlay" role="presentation">
    <div class="veiculo-confirm" role="dialog" aria-modal="true" aria-labelledby="veiculo-confirm-title">
      <header class="veiculo-confirm-header">
        <h3 id="veiculo-confirm-title" class="veiculo-confirm-title">{{ titulo }}</h3>
        <button
          type="button"
          class="veiculo-confirm-close"
          aria-label="Fechar"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="veiculo-confirm-body">
        <p class="veiculo-confirm-mensagem">{{ mensagem }}</p>
        <p v-if="error" class="veiculo-confirm-error" role="alert">{{ error }}</p>
      </div>

      <footer class="veiculo-confirm-footer">
        <button
          type="button"
          class="veiculo-confirm-btn veiculo-confirm-btn--secondary"
          :disabled="loading"
          @click="$emit('close')"
        >
          Cancelar
        </button>
        <button
          type="button"
          class="veiculo-confirm-btn"
          :class="variante === 'danger' ? 'veiculo-confirm-btn--danger' : 'veiculo-confirm-btn--primary'"
          :disabled="loading"
          @click="$emit('confirm')"
        >
          <span v-if="loading" class="veiculo-confirm-spinner" aria-hidden="true" />
          <span>{{ loading ? 'Processando...' : confirmLabel }}</span>
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { XMarkIcon } from '@heroicons/vue/24/outline'

interface Props {
  titulo: string
  mensagem: string
  confirmLabel: string
  variante?: 'default' | 'danger'
  loading?: boolean
  error?: string | null
}

withDefaults(defineProps<Props>(), {
  variante: 'default',
  loading: false,
  error: null
})

defineEmits<{
  confirm: []
  close: []
}>()
</script>

<style scoped>
.veiculo-confirm-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 110;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.veiculo-confirm {
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

.veiculo-confirm-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 20px 24px 16px;
  border-bottom: 1px solid #e5e7eb;
}

.veiculo-confirm-title {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #111827;
}

.veiculo-confirm-close {
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
  flex-shrink: 0;
}

.veiculo-confirm-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.veiculo-confirm-close svg {
  width: 20px;
  height: 20px;
}

.veiculo-confirm-body {
  padding: 20px 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  overflow-y: auto;
}

.veiculo-confirm-mensagem {
  margin: 0;
  font-size: 14px;
  color: #374151;
}

.veiculo-confirm-error {
  margin: 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.veiculo-confirm-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 24px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.veiculo-confirm-btn {
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

.veiculo-confirm-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.veiculo-confirm-btn--primary {
  background: #004790;
  color: #fff;
  border-color: #004790;
}

.veiculo-confirm-btn--primary:hover:not(:disabled) {
  background: #003570;
}

.veiculo-confirm-btn--danger {
  background: #dc2626;
  color: #fff;
  border-color: #dc2626;
}

.veiculo-confirm-btn--danger:hover:not(:disabled) {
  background: #b91c1c;
}

.veiculo-confirm-btn--secondary {
  background: #fff;
  color: #4b5563;
  border-color: #d1d5db;
}

.veiculo-confirm-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.veiculo-confirm-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: veiculo-confirm-spin 0.6s linear infinite;
}

@keyframes veiculo-confirm-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 600px) {
  .veiculo-confirm-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .veiculo-confirm-footer {
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .veiculo-confirm-btn {
    justify-content: center;
  }
}
</style>
