<template>
  <div class="jornada-lavador-modal-overlay" role="presentation">
    <div
      class="jornada-lavador-modal"
      role="dialog"
      aria-modal="true"
      aria-labelledby="jornada-lavador-modal-title"
    >
      <header class="jornada-lavador-modal-header">
        <div class="jornada-lavador-modal-header-text">
          <h2 id="jornada-lavador-modal-title" class="jornada-lavador-modal-title">
            Editar jornada
          </h2>
          <p class="jornada-lavador-modal-subtitle">
            Atualize as horas disponíveis da jornada.
          </p>
        </div>
        <button
          type="button"
          class="jornada-lavador-modal-close"
          aria-label="Fechar"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="jornada-lavador-modal-body">
        <JornadaLavadorForm
          :initial-data="jornada"
          @update:form-data="formData = $event"
        />
        <p v-if="error" class="jornada-lavador-modal-error" role="alert">{{ error }}</p>
      </div>

      <footer class="jornada-lavador-modal-footer">
        <button
          type="button"
          class="jornada-lavador-modal-btn jornada-lavador-modal-btn--secondary"
          :disabled="loading"
          @click="$emit('close')"
        >
          Cancelar
        </button>
        <button
          type="button"
          class="jornada-lavador-modal-btn jornada-lavador-modal-btn--primary"
          :disabled="loading"
          @click="onSave"
        >
          {{ loading ? 'Salvando...' : 'Salvar alterações' }}
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import JornadaLavadorForm from './JornadaLavadorForm.vue'
import type { JornadaLavador, JornadaLavadorFormData } from '@/utils/jornadaLavador'

interface Props {
  jornada?: JornadaLavador | null
  loading?: boolean
  error?: string | null
}

withDefaults(defineProps<Props>(), {
  jornada: null,
  loading: false,
  error: null
})

const emit = defineEmits<{
  close: []
  save: [data: JornadaLavadorFormData]
}>()

const formData = ref<JornadaLavadorFormData>({
  regime: 'NORMAL',
  horas_disponiveis: 8
})

const onSave = () => {
  emit('save', { ...formData.value })
}
</script>

<style scoped>
.jornada-lavador-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.jornada-lavador-modal {
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

.jornada-lavador-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 28px 20px;
  border-bottom: 1px solid #e5e7eb;
}

.jornada-lavador-modal-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.jornada-lavador-modal-title {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.jornada-lavador-modal-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.jornada-lavador-modal-close {
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

.jornada-lavador-modal-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.jornada-lavador-modal-close:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.jornada-lavador-modal-close svg {
  width: 20px;
  height: 20px;
}

.jornada-lavador-modal-body {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
}

.jornada-lavador-modal-error {
  margin: 16px 0 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.jornada-lavador-modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 28px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
  flex-wrap: wrap;
}

.jornada-lavador-modal-btn {
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

.jornada-lavador-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.jornada-lavador-modal-btn--primary:hover {
  background-color: #003570;
  border-color: #003570;
}

.jornada-lavador-modal-btn--primary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.35);
}

.jornada-lavador-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.jornada-lavador-modal-btn--secondary:hover {
  background: #f3f4f6;
}

.jornada-lavador-modal-btn--secondary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
}

@media (max-width: 600px) {
  .jornada-lavador-modal-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .jornada-lavador-modal {
    max-width: 100%;
    max-height: 92vh;
  }

  .jornada-lavador-modal-header {
    padding: 20px 20px 16px;
  }

  .jornada-lavador-modal-title {
    font-size: 18px;
  }

  .jornada-lavador-modal-body {
    padding: 20px;
  }

  .jornada-lavador-modal-footer {
    padding: 14px 20px 16px;
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .jornada-lavador-modal-btn {
    width: 100%;
  }
}
</style>
