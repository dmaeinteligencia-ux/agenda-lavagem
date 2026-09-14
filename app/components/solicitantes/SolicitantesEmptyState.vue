<template>
  <div class="solicitantes-empty-state">
    <UserGroupIcon class="solicitantes-empty-state-icon" aria-hidden="true" />
    <h3 class="solicitantes-empty-state-title">
      {{ variant === 'search' ? 'Nenhum solicitante encontrado.' : 'Nenhum solicitante cadastrado.' }}
    </h3>
    <p class="solicitantes-empty-state-desc">
      {{ variant === 'search' ? 'Tente alterar os termos da busca.' : 'Cadastre o primeiro solicitante para começar.' }}
    </p>
    <button
      v-if="variant !== 'search'"
      type="button"
      class="solicitantes-empty-state-btn"
      @click="$emit('new-solicitante')"
    >
      <PlusIcon class="solicitantes-empty-state-btn-icon" aria-hidden="true" />
      Novo Solicitante
    </button>
  </div>
</template>

<script setup lang="ts">
import { UserGroupIcon, PlusIcon } from '@heroicons/vue/24/outline'

interface Props {
  variant?: 'empty' | 'search'
}

withDefaults(defineProps<Props>(), {
  variant: 'empty'
})

defineEmits<{
  'new-solicitante': []
}>()
</script>

<style scoped>
.solicitantes-empty-state {
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

.solicitantes-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.solicitantes-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.solicitantes-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}

.solicitantes-empty-state-btn {
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

.solicitantes-empty-state-btn:hover {
  background-color: #003570;
}

.solicitantes-empty-state-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.solicitantes-empty-state-btn-icon {
  width: 18px;
  height: 18px;
}
</style>
