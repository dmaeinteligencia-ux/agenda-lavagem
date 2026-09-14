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
            {{ mode === 'edit' ? 'Editar Configuração' : 'Nova Configuração' }}
          </h2>
          <p class="calendario-operacional-modal-subtitle">
            {{ mode === 'edit' ? 'Atualize a configuração da data.' : 'Cadastre um feriado ou exceção de regime para uma data.' }}
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
        <CalendarioOperacionalForm
          ref="formRef"
          :initial-data="configuracao"
          :sugestao="sugestao"
          :mode="mode"
          @update:form-data="formData = $event"
        />
      </div>

      <footer class="calendario-operacional-modal-footer">
        <button
          type="button"
          class="calendario-operacional-modal-btn calendario-operacional-modal-btn--secondary"
          @click="$emit('close')"
        >
          Cancelar
        </button>
        <button
          type="button"
          class="calendario-operacional-modal-btn calendario-operacional-modal-btn--primary"
          @click="onSave"
        >
          {{ mode === 'edit' ? 'Salvar alterações' : 'Salvar' }}
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import CalendarioOperacionalForm from './CalendarioOperacionalForm.vue'
import type {
  CalendarioOperacionalMock,
  CalendarioOperacionalFormData,
  CalendarioOperacionalSugestao
} from '@/utils/calendarioOperacionalMock'

interface Props {
  mode?: 'create' | 'edit'
  configuracao?: CalendarioOperacionalMock | null
  sugestao?: CalendarioOperacionalSugestao | null
}

withDefaults(defineProps<Props>(), {
  mode: 'create',
  configuracao: null,
  sugestao: null
})

const emit = defineEmits<{
  close: []
  save: [data: CalendarioOperacionalFormData]
}>()

const formRef = ref<InstanceType<typeof CalendarioOperacionalForm>>()
const formData = ref<CalendarioOperacionalFormData>({
  data: '',
  regime: 'NORMAL',
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

.calendario-operacional-modal-close:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
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
  transition: background-color 0.2s, color 0.2s, box-shadow 0.2s, transform 0.1s;
}

.calendario-operacional-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.calendario-operacional-modal-btn--primary:hover {
  background-color: #003570;
  border-color: #003570;
}

.calendario-operacional-modal-btn--primary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.35);
}

.calendario-operacional-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.calendario-operacional-modal-btn--secondary:hover {
  background: #f3f4f6;
}

.calendario-operacional-modal-btn--secondary:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
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

  .calendario-operacional-modal-btn {
    width: 100%;
  }
}
</style>
