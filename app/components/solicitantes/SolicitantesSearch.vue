<template>
  <div class="solicitantes-search">
    <label for="solicitantes-search" class="solicitantes-search-label">Pesquisar</label>
    <div class="solicitantes-search-input-wrap">
      <MagnifyingGlassIcon class="solicitantes-search-icon" aria-hidden="true" />
      <input
        id="solicitantes-search"
        class="solicitantes-search-input"
        type="text"
        placeholder="Buscar por matrícula, nome ou telefone"
        :value="modelValue"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { MagnifyingGlassIcon } from '@heroicons/vue/24/outline'

interface Props {
  modelValue: string
}

defineProps<Props>()

defineEmits<{
  'update:modelValue': [value: string]
}>()
</script>

<style scoped>
.solicitantes-search {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
  min-width: 200px;
}

.solicitantes-search-label {
  font-size: 12px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.solicitantes-search-input-wrap {
  position: relative;
}

.solicitantes-search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.solicitantes-search-input {
  width: 100%;
  padding: 10px 12px 10px 38px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.solicitantes-search-input::placeholder {
  color: #9ca3af;
}

.solicitantes-search-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}
</style>
