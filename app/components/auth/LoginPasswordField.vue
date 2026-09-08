<template>
  <div class="password-field">
    <label for="login-password" class="field-label">Senha</label>
    <div class="field-input-wrapper">
      <LockClosedIcon class="field-icon field-icon--left" aria-hidden="true" />
      <input
        :key="showPassword ? 'visible' : 'hidden'"
        id="login-password"
        :value="modelValue"
        :type="showPassword ? 'text' : 'password'"
        class="field-input"
        placeholder="Digite sua senha"
        autocomplete="current-password"
        :disabled="disabled"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      />
      <button
        type="button"
        class="toggle-btn"
        :aria-label="showPassword ? 'Ocultar senha' : 'Mostrar senha'"
        :disabled="disabled"
        @click="showPassword = !showPassword"
      >
        <component :is="showPassword ? EyeSlashIcon : EyeIcon" aria-hidden="true" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { LockClosedIcon, EyeIcon, EyeSlashIcon } from '@heroicons/vue/24/outline'

interface Props {
  modelValue: string
  disabled?: boolean
}

withDefaults(defineProps<Props>(), {
  disabled: false
})

defineEmits<{
  'update:modelValue': [value: string]
}>()

const showPassword = ref(false)
</script>

<style scoped>
.password-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-label {
  font-size: 13px;
  font-weight: 600;
  color: #374151;
}

.field-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.field-icon--left {
  position: absolute;
  left: 14px;
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.field-input {
  width: 100%;
  padding: 12px 44px 12px 42px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
  font-family: inherit;
}

.field-input::placeholder {
  color: #9ca3af;
}

.field-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}

.field-input:disabled {
  background: #f3f4f6;
  cursor: not-allowed;
}

.toggle-btn {
  position: absolute;
  right: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  padding: 0;
  background: transparent;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  color: #9ca3af;
  transition: color 0.2s, background 0.2s;
}

.toggle-btn:hover:not(:disabled) {
  color: #004790;
  background: #f3f4f6;
}

.toggle-btn:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.toggle-btn svg {
  width: 18px;
  height: 18px;
}
</style>