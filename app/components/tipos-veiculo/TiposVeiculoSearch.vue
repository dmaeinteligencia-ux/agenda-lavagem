<template>
  <div class="tipos-veiculo-search">
    <label for="tipos-veiculo-search" class="tipos-veiculo-search-label">Pesquisar tipo de veículo...</label>
    <div class="tipos-veiculo-search-input-wrap">
      <MagnifyingGlassIcon class="tipos-veiculo-search-icon" aria-hidden="true" />
      <input
        id="tipos-veiculo-search"
        class="tipos-veiculo-search-input"
        type="text"
        :value="modelValue"
        placeholder="Pesquisar tipo de veículo..."
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
.tipos-veiculo-search {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
  min-width: 200px;
}

.tipos-veiculo-search-label {
  font-size: 12px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.tipos-veiculo-search-input-wrap {
  position: relative;
}

.tipos-veiculo-search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.tipos-veiculo-search-input {
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

.tipos-veiculo-search-input::placeholder {
  color: #9ca3af;
}

.tipos-veiculo-search-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}
</style>