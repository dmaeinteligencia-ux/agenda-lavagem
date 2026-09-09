<template>
  <Dialog
    :visible="isVisible"
    :header="modalTitle"
    :modal="true"
    :style="{ width: '550px' }"
    :closable="true"
    :dismissableMask="true"
    @update:visible="onVisibleUpdate"
    @hide="onHide"
    class="jornada-lavador-modal"
  >
    <template #header>
      <div class="jornada-lavador-modal-header">
        <div>
          <h3 class="jornada-lavador-modal-title">{{ modalTitle }}</h3>
          <p class="jornada-lavador-modal-subtitle">
            {{ mode === 'edit' ? 'Atualize as informações da jornada.' : 'Cadastre uma nova jornada e defina o tempo configurado.' }}
          </p>
        </div>
      </div>
    </template>

    <div class="jornada-lavador-modal-body">
      <JornadaLavadorForm
        ref="formRef"
        :initialData="jornadaEdicao"
        :mode="mode"
        @update:formData="formData = $event"
        @validate="onValidate"
      />
    </div>

    <template #footer>
      <div class="jornada-lavador-modal-footer">
        <Button
          label="Cancelar"
          class="p-button-outlined"
          @click="onCancel"
          :disabled="loading"
        />
        <Button
          :label="mode === 'edit' ? 'Salvar alterações' : 'Salvar'"
          class="p-button-primary"
          @click="onSave"
          :loading="loading"
        />
      </div>
    </template>
  </Dialog>
</template>

<script setup lang="ts>
import { ref, computed, watch } from 'vue'
import { Dialog } from 'primevue/dialog'
import { Button } from 'primevue/button'
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

const modalTitle = computed(() => props.mode === 'edit' ? 'Editar Jornada' : 'Nova Jornada')

const isVisible = ref(props.visible)

watch(() => props.visible, (newVal) => {
  isVisible.value = newVal
})

const onVisibleUpdate = (value: boolean) => {
  isVisible.value = value
  emit('update:visible', value)
}

const onHide = () => {
  isVisible.value = false
  emit('update:visible', false)
}

const onCancel = () => {
  isVisible.value = false
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
        isVisible.value = false
        emit('update:visible', false)
      }, 600)
    }
  }
}

watch(() => props.visible, (newVal) => {
  if (!newVal) {
    submitted.value = false
    formData.value = null
  }
})
</script>

<style scoped>
.jornada-lavador-modal :deep(.p-dialog-header) {
  padding: 20px 24px;
  border-bottom: 1px solid #e5e7eb;
  background: #fff;
}

.jornada-lavador-modal :deep(.p-dialog-content) {
  padding: 0;
}

.jornada-lavador-modal :deep(.p-dialog-footer) {
  padding: 0;
  border-top: none;
  background: #fff;
}

.jornada-lavador-modal-header {
  display: flex;
  flex-direction: column;
  gap: 4px;
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

.jornada-lavador-modal-body {
  padding: 24px;
}

.jornada-lavador-modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 24px;
  background: #f9fafb;
  border-top: 1px solid #e5e7eb;
}

.jornada-lavador-modal :deep(.p-button-primary) {
  background-color: #004790;
  border-color: #004790;
  font-weight: 600;
}

.jornada-lavador-modal :deep(.p-button-primary:hover) {
  background-color: #003570;
  border-color: #003570;
}

.jornada-lavador-modal :deep(.p-button-outlined) {
  color: #4b5563;
  border-color: #d1d5db;
}

.jornada-lavador-modal :deep(.p-button-outlined:hover) {
  background: #f3f4f6;
  border-color: #9ca3af;
}

@media (max-width: 600px) {
  .jornada-lavador-modal :deep(.p-dialog) {
    width: 95vw !important;
    margin: 12px;
  }
  
  .jornada-lavador-modal-body {
    padding: 16px;
  }
  
  .jornada-lavador-modal-footer {
    flex-direction: column-reverse;
    padding: 12px 16px;
  }
  
  .jornada-lavador-modal-footer .p-button {
    width: 100%;
  }
}
</style>