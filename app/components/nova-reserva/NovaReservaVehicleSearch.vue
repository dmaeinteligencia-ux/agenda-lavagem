<template>
  <div class="nova-reserva-vehicle-search">
    <div class="nova-reserva-vehicle-search-field">
      <label for="nova-reserva-plate" class="nova-reserva-vehicle-search-label">
        Placa do veículo
      </label>
      <div class="nova-reserva-vehicle-search-input-wrap">
        <MagnifyingGlassIcon class="nova-reserva-vehicle-search-icon" aria-hidden="true" />
        <input
          id="nova-reserva-plate"
          v-model="plate"
          class="nova-reserva-vehicle-search-input"
          type="text"
          placeholder="Digite a placa do veículo"
          autocomplete="off"
          @keyup.enter="buscar"
        />
      </div>
    </div>
    <button type="button" class="nova-reserva-vehicle-search-btn" :disabled="loading" @click="buscar">
      <span v-if="loading" class="nova-reserva-vehicle-search-spinner" aria-hidden="true" />
      <span>{{ loading ? 'Buscando...' : 'Pesquisar' }}</span>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { MagnifyingGlassIcon } from '@heroicons/vue/24/outline'

interface Props {
  loading: boolean
}

withDefaults(defineProps<Props>(), {
  loading: false
})

const emit = defineEmits<{
  buscar: [placa: string]
}>()

const plate = ref('')

const buscar = () => {
  if (!plate.value.trim()) {
    return
  }
  emit('buscar', plate.value.trim())
}
</script>

<style scoped>
.nova-reserva-vehicle-search {
  display: flex;
  align-items: flex-end;
  gap: 12px;
  flex-wrap: wrap;
}

.nova-reserva-vehicle-search-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  flex: 1;
  min-width: 220px;
}

.nova-reserva-vehicle-search-label {
  font-size: 13px;
  font-weight: 500;
  color: #374151;
}

.nova-reserva-vehicle-search-input-wrap {
  position: relative;
}

.nova-reserva-vehicle-search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.nova-reserva-vehicle-search-input {
  width: 100%;
  padding: 10px 12px 10px 38px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.nova-reserva-vehicle-search-input::placeholder {
  color: #9ca3af;
}

.nova-reserva-vehicle-search-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.nova-reserva-vehicle-search-btn {
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 600;
  color: #004790;
  background: #fff;
  border: 1px solid #004790;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, color 0.2s, box-shadow 0.2s;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.nova-reserva-vehicle-search-btn:hover:not(:disabled) {
  background: #e8f0fe;
}

.nova-reserva-vehicle-search-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.nova-reserva-vehicle-search-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: vehicle-spin 0.6s linear infinite;
}

@keyframes vehicle-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 600px) {
  .nova-reserva-vehicle-search-btn {
    width: 100%;
  }
}
</style>
