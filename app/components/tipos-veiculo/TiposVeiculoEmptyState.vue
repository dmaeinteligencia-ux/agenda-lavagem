<template>
  <div class="tipos-veiculo-empty-state">
    <TruckIcon class="tipos-veiculo-empty-state-icon" aria-hidden="true" />
    <h3 class="tipos-veiculo-empty-state-title">{{ title }}</h3>
    <p class="tipos-veiculo-empty-state-desc">{{ description }}</p>
    <button
      v-if="acao"
      type="button"
      class="tipos-veiculo-empty-state-btn"
      @click="$emit('action')"
    >
      <PlusIcon class="tipos-veiculo-empty-state-btn-icon" aria-hidden="true" />
      Novo Tipo
    </button>
  </div>
</template>

<script setup lang="ts">
import { TruckIcon, PlusIcon } from '@heroicons/vue/24/outline'

interface Props {
  title?: string
  description?: string
  acao?: boolean
}

withDefaults(defineProps<Props>(), {
  title: 'Nenhum tipo de veículo cadastrado',
  description: 'Os tipos de veículos cadastrados aparecerão aqui.',
  acao: false
})

defineEmits<{
  action: []
}>()
</script>

<style scoped>
.tipos-veiculo-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 24px;
  text-align: center;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.tipos-veiculo-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.tipos-veiculo-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.tipos-veiculo-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}

.tipos-veiculo-empty-state-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, box-shadow 0.2s;
}

.tipos-veiculo-empty-state-btn:hover {
  background-color: #003570;
}

.tipos-veiculo-empty-state-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.tipos-veiculo-empty-state-btn-icon {
  width: 18px;
  height: 18px;
}
</style>
