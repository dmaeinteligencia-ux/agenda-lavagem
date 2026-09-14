<template>
  <div class="calendario-operacional-empty-state">
    <CalendarIcon class="calendario-operacional-empty-state-icon" aria-hidden="true" />
    <h3 class="calendario-operacional-empty-state-title">
      {{ variant === 'search' ? 'Nenhuma configuração encontrada.' : 'Nenhuma configuração cadastrada.' }}
    </h3>
    <p class="calendario-operacional-empty-state-desc">
      {{ variant === 'search' ? 'Tente alterar os filtros ou os termos da busca.' : 'Cadastre feriados ou exceções para ajustar o calendário operacional.' }}
    </p>
    <button
      v-if="variant !== 'search'"
      type="button"
      class="calendario-operacional-empty-state-btn"
      @click="$emit('new-configuracao')"
    >
      <PlusIcon class="calendario-operacional-empty-state-btn-icon" aria-hidden="true" />
      Nova Configuração
    </button>
  </div>
</template>

<script setup lang="ts">
import { CalendarIcon, PlusIcon } from '@heroicons/vue/24/outline'

interface Props {
  variant?: 'empty' | 'search'
}

withDefaults(defineProps<Props>(), {
  variant: 'empty'
})

defineEmits<{
  'new-configuracao': []
}>()
</script>

<style scoped>
.calendario-operacional-empty-state {
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

.calendario-operacional-empty-state-icon {
  width: 56px;
  height: 56px;
  color: #d1d5db;
}

.calendario-operacional-empty-state-title {
  font-size: 16px;
  font-weight: 600;
  color: #374151;
  margin: 0;
}

.calendario-operacional-empty-state-desc {
  font-size: 14px;
  color: #9ca3af;
  margin: 0;
}

.calendario-operacional-empty-state-btn {
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

.calendario-operacional-empty-state-btn:hover {
  background-color: #003570;
}

.calendario-operacional-empty-state-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.calendario-operacional-empty-state-btn-icon {
  width: 18px;
  height: 18px;
}
</style>
