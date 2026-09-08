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
            {{ mode === 'edit' ? 'Editar Veículo' : 'Novo Veículo' }}
          </h2>
          <p class="veiculo-modal-subtitle">
            {{ mode === 'edit' ? 'Atualize as informações do veículo da frota.' : 'Cadastre as informações do veículo da frota.' }}
          </p>
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
        <VeiculoForm />
      </div>

      <footer class="veiculo-modal-footer">
        <button type="button" class="veiculo-modal-btn veiculo-modal-btn--secondary">
          Cancelar
        </button>
        <button type="button" class="veiculo-modal-btn veiculo-modal-btn--primary">
          {{ mode === 'edit' ? 'Salvar alterações' : 'Salvar' }}
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { XMarkIcon } from '@heroicons/vue/24/outline'
import VeiculoForm from './VeiculoForm.vue'

interface Props {
  mode?: 'create' | 'edit'
}

withDefaults(defineProps<Props>(), {
  mode: 'create'
})
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
  padding: 10px 22px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.veiculo-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.veiculo-modal-btn--primary:hover {
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

.veiculo-modal-btn--secondary:hover {
  background: #f3f4f6;
}

.veiculo-modal-btn--secondary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
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