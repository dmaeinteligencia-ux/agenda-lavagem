<template>
  <div v-if="showModalInternal" class="jornada-lavador-modal-overlay" @click.self="onCancel">
    <div class="jornada-lavador-modal">
      <div class="jornada-lavador-modal-header">
        <div>
          <h3 class="jornada-lavador-modal-title">{{ modalTitle }}</h3>
          <p class="jornada-lavador-modal-subtitle">
            {{ mode === 'edit' ? 'Atualize as informações da jornada.' : 'Cadastre uma nova jornada e defina o tempo configurado.' }}
          </p>
        </div>
        <button class="jornada-lavador-modal-close" @click="onCancel" aria-label="Fechar">
          <XMarkIcon class="jornada-lavador-modal-close-icon" />
        </button>
      </div>

      <div class="jornada-lavador-modal-body">
        <JornadaLavadorForm
          ref="formRef"
          :initialData="jornadaEdicao"
          :mode="mode"
          @update:formData="formData = $event"
          @validate="onValidate"
        />
      </div>

      <div class="jornada-lavador-modal-footer">
        <button class="jornada-lavador-modal-btn jornada-lavador-modal-btn--secondary" @click="onCancel" :disabled="loading">
          Cancelar
        </button>
        <button class="jornada-lavador-modal-btn jornada-lavador-modal-btn--primary" @click="onSave" :disabled="loading">
          <span v-if="!loading">{{ mode === 'edit' ? 'Salvar alterações' : 'Salvar' }}</span>
          <span v-else class="jornada-lavador-modal-btn-loading">Salvando...</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import JornadaLavadorForm from './JornadaLavadorForm.vue'
import type { JornadaLavador } from '@/utils/jornadaLavadorMock'

interface Props {
  visible: boolean
  mode?: 'create' | 'edit'
  jornadaEdicao?: JornadaLavador | null
}

const props = withDefaults(defineProps<Props>(), {
  visible: false,
  mode: 'create',
  jornadaEdicao: null
})

const emit = defineEmits(['update:visible', 'save', 'cancel'])

const formRef = ref<InstanceType<typeof JornadaLavadorForm>>()
const formData = ref<JornadaLavador | null>(null)
const loading = ref(false)
const submitted = ref(false)
const showModalInternal = ref(props.visible)

const modalTitle = computed(() => props.mode === 'edit' ? 'Editar Jornada' : 'Nova Jornada')

watch(() => props.visible, (newVal) => {
  showModalInternal.value = newVal
})

const onCancel = () => {
  showModalInternal.value = false
  emit('update:visible', false)
  emit('cancel')
}

const onValidate = (isValid: boolean) => {
  submitted.value = !isValid
}

const onSave = () => {
  if (formRef.value && formData.value) {
    formRef.value.validate()
    if (!submitted.value) {
      loading.value = true
      emit('save', { ...formData.value })
      setTimeout(() => {
        loading.value = false
        showModalInternal.value = false
        emit('update:visible', false)
      }, 600)
    }
  }
}

watch(() => props.visible, (newVal) => {
  if (!newVal) {
    submitted.value = false
  }
})
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
  max-width: 550px;
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

.jornada-lavador-modal-title {
  font-size: 18px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.jornada-lavador-modal-subtitle {
  font-size: 13px;
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

.jornada-lavador-modal-close-icon {
  width: 20px;
  height: 20px;
}

.jornada-lavador-modal-body {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
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
  transition: background-color 0.2s;
}

.jornada-lavador-modal-btn--primary {
  background-color: #004790;
  color: #fff;
  border: 1px solid #004790;
}

.jornada-lavador-modal-btn--primary:hover:not(:disabled) {
  background-color: #003570;
  border-color: #003570;
}

.jornada-lavador-modal-btn--primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.jornada-lavador-modal-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.jornada-lavador-modal-btn--secondary:hover:not(:disabled) {
  background: #f3f4f6;
}

.jornada-lavador-modal-btn--secondary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

@media (max-width: 600px) {
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