<template>
  <div class="perfil-modal-overlay" role="presentation">
    <div class="perfil-modal" role="dialog" aria-modal="true" aria-labelledby="perfil-modal-title">
      <header class="perfil-modal-header">
        <div>
          <h2 id="perfil-modal-title" class="perfil-modal-title">Alterar perfil</h2>
          <p class="perfil-modal-subtitle">
            {{ usuario.nome || usuario.email }}
          </p>
        </div>
        <button type="button" class="perfil-modal-close" aria-label="Fechar" @click="$emit('close')">
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="perfil-modal-body">
        <p class="perfil-modal-label">Selecione o novo perfil</p>
        <div class="perfil-options">
          <label
            v-for="opcao in opcoes"
            :key="opcao.value"
            class="perfil-option"
            :class="{ 'perfil-option--selected': selecionado === opcao.value }"
          >
            <input
              v-model="selecionado"
              type="radio"
              name="novo-perfil"
              :value="opcao.value"
              class="perfil-radio"
            />
            <span class="perfil-option-text">{{ opcao.label }}</span>
          </label>
        </div>

        <p v-if="error" class="perfil-modal-error" role="alert">{{ error }}</p>
      </div>

      <footer class="perfil-modal-footer">
        <button type="button" class="perfil-btn perfil-btn--secondary" :disabled="loading" @click="$emit('close')">
          Cancelar
        </button>
        <button type="button" class="perfil-btn perfil-btn--primary" :disabled="loading" @click="$emit('save', selecionado)">
          {{ loading ? 'Salvando...' : 'Salvar' }}
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import type { Usuario } from '@/composables/useUsuarios'

interface Props {
  usuario: Usuario
  loading?: boolean
  error?: string | null
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  error: null
})

const emit = defineEmits<{
  close: []
  save: [perfil: 'ADMIN' | 'GESTAO_FROTA' | 'LAVADOR']
}>()

const opcoes = [
  { value: 'ADMIN' as const, label: 'Administrador' },
  { value: 'GESTAO_FROTA' as const, label: 'Gestão de Frota' },
  { value: 'LAVADOR' as const, label: 'Lavador' }
]

const selecionado = ref<'ADMIN' | 'GESTAO_FROTA' | 'LAVADOR'>(props.usuario.perfil)
</script>

<style scoped>
.perfil-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.perfil-modal {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 420px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.perfil-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 24px 16px;
  border-bottom: 1px solid #e5e7eb;
}

.perfil-modal-title {
  font-size: 18px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.perfil-modal-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 4px 0 0;
}

.perfil-modal-close {
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

.perfil-modal-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.perfil-modal-close svg {
  width: 20px;
  height: 20px;
}

.perfil-modal-body {
  padding: 20px 24px;
}

.perfil-modal-label {
  margin: 0 0 12px;
  font-size: 13px;
  font-weight: 600;
  color: #374151;
}

.perfil-options {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.perfil-option {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 14px;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  cursor: pointer;
  transition: border-color 0.15s, background-color 0.15s;
}

.perfil-option:hover {
  border-color: #004790;
}

.perfil-option--selected {
  border-color: #004790;
  background: #f0f6ff;
}

.perfil-radio {
  accent-color: #004790;
}

.perfil-option-text {
  font-size: 14px;
  color: #1f2937;
}

.perfil-modal-error {
  margin: 16px 0 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.perfil-modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 24px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.perfil-btn {
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
}

.perfil-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.perfil-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.perfil-btn--primary {
  background: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.perfil-btn--primary:hover:not(:disabled) {
  background: #003570;
}

.perfil-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
