<template>
  <div class="nova-reserva-actions">
    <button
      type="button"
      class="nova-reserva-actions-btn nova-reserva-actions-btn--secondary"
      :disabled="loading"
      @click="$emit('cancelar')"
    >
      Cancelar
    </button>
    <button
      type="button"
      class="nova-reserva-actions-btn nova-reserva-actions-btn--primary"
      :disabled="disabled || loading"
      @click="$emit('confirmar')"
    >
      <span v-if="loading" class="nova-reserva-actions-spinner" aria-hidden="true" />
      <CheckCircleIcon v-else class="nova-reserva-actions-btn-icon" aria-hidden="true" />
      {{ loading ? 'Criando...' : 'Confirmar Reserva' }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { CheckCircleIcon } from '@heroicons/vue/24/outline'

interface Props {
  disabled?: boolean
  loading?: boolean
}

withDefaults(defineProps<Props>(), {
  disabled: false,
  loading: false
})

defineEmits<{
  cancelar: []
  confirmar: []
}>()
</script>

<style scoped>
.nova-reserva-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  flex-wrap: wrap;
}

.nova-reserva-actions-btn {
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

.nova-reserva-actions-btn-icon {
  width: 18px;
  height: 18px;
}

.nova-reserva-actions-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: nova-reserva-spin 0.6s linear infinite;
}

@keyframes nova-reserva-spin {
  to {
    transform: rotate(360deg);
  }
}

.nova-reserva-actions-btn--primary {
  background-color: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.nova-reserva-actions-btn--primary:hover:not(:disabled) {
  background-color: #003570;
  border-color: #003570;
}

.nova-reserva-actions-btn--primary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.35);
}

.nova-reserva-actions-btn--primary:active:not(:disabled) {
  transform: translateY(1px);
}

.nova-reserva-actions-btn--primary:disabled {
  background-color: #9ca3af;
  border-color: #9ca3af;
  cursor: not-allowed;
  opacity: 0.7;
}

.nova-reserva-actions-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.nova-reserva-actions-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.nova-reserva-actions-btn--secondary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
}

.nova-reserva-actions-btn--secondary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

@media (max-width: 600px) {
  .nova-reserva-actions {
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .nova-reserva-actions-btn {
    width: 100%;
  }
}
</style>
