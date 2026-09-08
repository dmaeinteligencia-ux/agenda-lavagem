<template>
  <button
    type="submit"
    class="submit-btn"
    :disabled="disabled"
  >
    <span v-if="loading" class="submit-spinner" aria-hidden="true" />
    {{ loading ? 'Entrando...' : 'Entrar no sistema' }}
  </button>
</template>

<script setup lang="ts">
interface Props {
  loading?: boolean
  disabled?: boolean
}

withDefaults(defineProps<Props>(), {
  loading: false,
  disabled: false
})
</script>

<style scoped>
.submit-btn {
  width: 100%;
  padding: 14px 20px;
  font-size: 15px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, box-shadow 0.2s, transform 0.1s;
  margin-top: 4px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.submit-btn:hover:not(:disabled) {
  background-color: #003570;
}

.submit-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.submit-btn:active:not(:disabled) {
  transform: translateY(1px);
}

.submit-btn:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
  opacity: 0.7;
}

.submit-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: submit-spin 0.6s linear infinite;
}

@keyframes submit-spin {
  to { transform: rotate(360deg); }
}
</style>