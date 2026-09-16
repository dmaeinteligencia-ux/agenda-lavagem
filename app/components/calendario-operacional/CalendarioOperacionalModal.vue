<template>
  <div class="calendario-operacional-modal-overlay" role="presentation">
    <div
      class="calendario-operacional-modal"
      role="dialog"
      aria-modal="true"
      :aria-labelledby="`calendario-operacional-modal-title-${mode}`"
    >
      <header class="calendario-operacional-modal-header">
        <div class="calendario-operacional-modal-header-text">
          <h2 :id="`calendario-operacional-modal-title-${mode}`" class="calendario-operacional-modal-title">
            {{ confirmandoRemocao ? 'Restaurar padrão' : mode === 'edit' ? 'Editar Configuração' : 'Nova Configuração' }}
          </h2>
          <p class="calendario-operacional-modal-subtitle">
            {{
              confirmandoRemocao
                ? 'A configuração manual desta data será removida.'
                : mode === 'edit'
                  ? 'Atualize a configuração da data.'
                  : 'Cadastre uma exceção (feriado, ponto facultativo, etc.) para uma data.'
            }}
          </p>
        </div>
        <button
          type="button"
          class="calendario-operacional-modal-close"
          aria-label="Fechar"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="calendario-operacional-modal-body">
        <template v-if="confirmandoRemocao">
          <p class="calendario-operacional-modal-confirm-text">
            Esta data voltará a seguir a regra automática (dia útil, fim de semana ou feriado oficial).
          </p>
          <p v-if="error" class="calendario-operacional-modal-error" role="alert">{{ error }}</p>
        </template>

        <template v-else>
          <CalendarioOperacionalForm
            ref="formRef"
            :initial-data="configuracao"
            :sugestao="sugestao"
            :mode="mode"
            @update:form-data="formData = $event"
          />
          <p v-if="error" class="calendario-operacional-modal-error" role="alert">{{ error }}</p>
        </template>
      </div>

      <footer class="calendario-operacional-modal-footer">
        <template v-if="confirmandoRemocao">
          <button
            type="button"
            class="calendario-operacional-modal-btn calendario-operacional-modal-btn--secondary"
            :disabled="loading"
            @click="confirmandoRemocao = false"
          >
            Voltar
          </button>
          <button
            type="button"
            class="calendario-operacional-modal-btn calendario-operacional-modal-btn--danger"
            :disabled="loading"
            @click="$emit('remove')"
          >
            {{ loading ? 'Restaurando...' : 'Confirmar remoção' }}
          </button>
        </template>

        <template v-else>
          <button
            v-if="mode === 'edit'"
            type="button"
            class="calendario-operacional-modal-btn calendario-operacional-modal-btn--danger-ghost"
            :disabled="loading"
            @click="confirmandoRemocao = true"
          >
            Restaurar padrão
          </button>
          <span class="calendario-operacional-modal-spacer" />
          <button
            type="button"
            class="calendario-operacional-modal-btn calendario-operacional-modal-btn--secondary"
            :disabled="loading"
            @click="$emit('close')"
          >
            Cancelar
          </button>
          <button
            type="button"
            class="calendario-operacional-modal-btn calendario-operacional-modal-btn--primary"
            :disabled="loading"
            @click="onSave"
          >
            {{ loading ? 'Salvando...' : mode === 'edit' ? 'Salvar alterações' : 'Salvar' }}
          </button>
        </template>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import CalendarioOperacionalForm from './CalendarioOperacionalForm.vue'
import type {
  CalendarioConfiguracao,
  CalendarioOperacionalFormData,
  CalendarioOperacionalSugestao
} from '@/utils/calendarioOperacional'

interface Props {
  mode?: 'create' | 'edit'
  configuracao?: CalendarioConfiguracao | null
  sugestao?: CalendarioOperacionalSugestao | null
  loading?: boolean
  error?: string | null
}

withDefaults(defineProps<Props>(), {
  mode: 'create',
  configuracao: null,
  sugestao: null,
  loading: false,
  error: null
})

const emit = defineEmits<{
  close: []
  save: [data: CalendarioOperacionalFormData]
  remove: []
}>()

const formRef = ref<InstanceType<typeof CalendarioOperacionalForm>>()
const confirmandoRemocao = ref(false)
const formData = ref<CalendarioOperacionalFormData>({
  data: '',
  regime: 'NORMAL',
  ativo: true,
  tipo_configuracao: 'OUTRO',
  observacao: ''
})

const onSave = () => {
  if (formRef.value && formRef.value.validate()) {
    emit('save', { ...formData.value })
  }
}
</script>

<style scoped>
.calendario-operacional-modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.calendario-operacional-modal {
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

.calendario-operacional-modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 28px 20px;
  border-bottom: 1px solid #e5e7eb;
}

.calendario-operacional-modal-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.calendario-operacional-modal-title {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.calendario-operacional-modal-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.calendario-operacional-modal-close {
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

.calendario-operacional-modal-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.calendario-operacional-modal-close svg {
  width: 20px;
  height: 20px;
}

.calendario-operacional-modal-body {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
}

.calendario-operacional-modal-confirm-text {
  margin: 0;
  font-size: 14px;
  color: #374151;
}

.calendario-operacional-modal-error {
  margin: 16px 0 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.calendario-operacional-modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 28px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
  flex-wrap: wrap;
}

.calendario-operacional-modal-spacer {
  flex: 1;
}

.calendario-operacional-modal-btn {
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

.calendario-operacional-modal-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.calendario-operacional-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border-color: #004790;
}

.calendario-operacional-modal-btn--primary:hover:not(:disabled) {
  background-color: #003570;
}

.calendario-operacional-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border-color: #d1d5db;
}

.calendario-operacional-modal-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.calendario-operacional-modal-btn--danger {
  background: #dc2626;
  color: #fff;
  border-color: #dc2626;
}

.calendario-operacional-modal-btn--danger:hover:not(:disabled) {
  background: #b91c1c;
}

.calendario-operacional-modal-btn--danger-ghost {
  background: #fff;
  color: #b91c1c;
  border-color: #fecaca;
}

.calendario-operacional-modal-btn--danger-ghost:hover:not(:disabled) {
  background: #fef2f2;
}

@media (max-width: 600px) {
  .calendario-operacional-modal-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .calendario-operacional-modal {
    max-width: 100%;
    max-height: 92vh;
  }

  .calendario-operacional-modal-header {
    padding: 20px 20px 16px;
  }

  .calendario-operacional-modal-title {
    font-size: 18px;
  }

  .calendario-operacional-modal-body {
    padding: 20px;
  }

  .calendario-operacional-modal-footer {
    padding: 14px 20px 16px;
    flex-direction: column-reverse;
    align-items: stretch;
  }

  .calendario-operacional-modal-spacer {
    display: none;
  }

  .calendario-operacional-modal-btn {
    width: 100%;
  }
}
</style>
