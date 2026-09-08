<template>
  <div class="email-field">
    <label for="login-email" class="field-label">E-mail</label>
    <div class="field-input-wrapper">
      <EnvelopeIcon class="field-icon" aria-hidden="true" />
      <input
        id="login-email"
        :value="modelValue"
        type="email"
        name="email"
        class="field-input"
        placeholder="Digite seu e-mail"
        autocomplete="email"
        :disabled="disabled"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { EnvelopeIcon } from '@heroicons/vue/24/outline'

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
</script>

<style scoped>
.email-field {
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

.field-icon {
  position: absolute;
  left: 14px;
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.field-input {
  width: 100%;
  padding: 12px 14px 12px 42px;
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
</style>