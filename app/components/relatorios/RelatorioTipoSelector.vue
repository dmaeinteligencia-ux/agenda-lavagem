<template>
  <div class="relatorio-tipo-selector" role="tablist" aria-label="Tipo de relatório">
    <button
      v-for="opcao in opcoes"
      :key="opcao.value"
      type="button"
      role="tab"
      class="relatorio-tipo-btn"
      :class="{ 'relatorio-tipo-btn--active': opcao.value === modelValue }"
      :aria-selected="opcao.value === modelValue"
      @click="$emit('update:modelValue', opcao.value)"
    >
      {{ opcao.label }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { TIPO_RELATORIO_OPCOES, type TipoRelatorio } from '@/utils/relatorios'

interface Props {
  modelValue: TipoRelatorio
}

defineProps<Props>()

defineEmits<{
  'update:modelValue': [value: TipoRelatorio]
}>()

const opcoes = TIPO_RELATORIO_OPCOES
</script>

<style scoped>
.relatorio-tipo-selector {
  display: flex;
  gap: 4px;
  padding: 4px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow-x: auto;
}

.relatorio-tipo-btn {
  flex: 1 1 auto;
  padding: 10px 16px;
  font-size: 14px;
  font-weight: 600;
  color: #4b5563;
  background: transparent;
  border: none;
  border-radius: 7px;
  cursor: pointer;
  font-family: inherit;
  white-space: nowrap;
  transition: background-color 0.15s, color 0.15s;
}

.relatorio-tipo-btn:hover:not(.relatorio-tipo-btn--active) {
  background: #f3f4f6;
  color: #004790;
}

.relatorio-tipo-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.relatorio-tipo-btn--active {
  background: #004790;
  color: #fff;
}

@media (max-width: 600px) {
  .relatorio-tipo-selector {
    flex-direction: column;
  }

  .relatorio-tipo-btn {
    text-align: left;
  }
}
</style>
