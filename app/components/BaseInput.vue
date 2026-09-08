<template>
  <div class="base-input-wrapper">
    <label v-if="label" :for="inputId" class="base-input-label">{{ label }}</label>
    <input
      :id="inputId"
      class="base-input"
      :class="{ 'base-input--error': error }"
      :type="type"
      :placeholder="placeholder"
      :value="modelValue"
      :disabled="disabled"
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
    />
    <span v-if="error" class="base-input-error">{{ error }}</span>
  </div>
</template>

<script setup lang="ts">
import { useId } from 'vue'

interface Props {
  modelValue?: string | number
  label?: string
  type?: string
  placeholder?: string
  disabled?: boolean
  error?: string
}

defineProps<Props>()

defineEmits<{
  'update:modelValue': [value: string]
}>()

const inputId = useId()
</script>

<style scoped>
.base-input-wrapper {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.base-input-label {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.base-input {
  padding: 10px 12px;
  font-size: 14px;
  border: 2px solid #d1d5db;
  border-radius: 8px;
  outline: none;
  transition: border-color 0.2s;
  background: #fff;
}

.base-input:focus {
  border-color: #004790;
}

.base-input--error {
  border-color: #dc2626;
}

.base-input-error {
  font-size: 12px;
  color: #dc2626;
}
</style>