<template>
  <div class="nova-reserva-date-field">
    <label for="nova-reserva-date" class="nova-reserva-date-field-label">
      {{ label }}
    </label>
    <div class="nova-reserva-date-field-wrap">
      <CalendarDaysIcon class="nova-reserva-date-field-icon" aria-hidden="true" />
      <input
        id="nova-reserva-date"
        class="nova-reserva-date-field-input"
        type="date"
        :value="modelValue"
        :min="min"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { CalendarDaysIcon } from '@heroicons/vue/24/outline'

interface Props {
  label: string
  modelValue: string
  min?: string
}

withDefaults(defineProps<Props>(), {
  min: undefined
})

defineEmits<{
  'update:modelValue': [value: string]
}>()
</script>

<style scoped>
.nova-reserva-date-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.nova-reserva-date-field-label {
  font-size: 13px;
  font-weight: 500;
  color: #374151;
}

.nova-reserva-date-field-wrap {
  position: relative;
}

.nova-reserva-date-field-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: #004790;
  pointer-events: none;
}

.nova-reserva-date-field-input {
  width: 100%;
  padding: 10px 12px 10px 38px;
  font-size: 14px;
  font-weight: 600;
  color: #1f2937;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.2s, box-shadow 0.2s;
  font-family: inherit;
}

.nova-reserva-date-field-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}
</style>
