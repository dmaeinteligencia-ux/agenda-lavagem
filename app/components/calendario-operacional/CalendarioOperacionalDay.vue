<template>
  <button
    type="button"
    class="calendario-operacional-day"
    :class="[
      `calendario-operacional-day--${regimeExibido.toLowerCase()}`,
      { 'calendario-operacional-day--especifica': temConfiguracao }
    ]"
    :aria-label="ariaLabel"
    @click="$emit('click')"
  >
    <span class="calendario-operacional-day-numero">{{ dia }}</span>
    <span class="calendario-operacional-day-regime">{{ regimeExibido }}</span>
    <span v-if="temConfiguracao" class="calendario-operacional-day-marcador" aria-hidden="true" />
    <span v-if="config?.observacao" class="calendario-operacional-day-observacao">{{ config.observacao }}</span>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { getRegimePadrao } from '@/utils/calendarioOperacionalMock'
import type { CalendarioOperacionalMock, RegimeOperacional } from '@/utils/calendarioOperacionalMock'

interface Props {
  dia: number
  iso: string
  config: CalendarioOperacionalMock | null
}

const props = defineProps<Props>()

defineEmits<{
  click: []
}>()

const temConfiguracao = computed(() => !!props.config)

const regimeExibido = computed<RegimeOperacional>(() =>
  props.config?.regime ?? getRegimePadrao(props.iso)
)

const ariaLabel = computed(() => {
  const observacao = props.config?.observacao ? ` — ${props.config.observacao}` : ''
  return `${props.dia}, ${regimeExibido.value}${observacao}`
})
</script>

<style scoped>
.calendario-operacional-day {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 4px;
  padding: 8px 10px;
  min-height: 96px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #fff;
  cursor: pointer;
  text-align: left;
  font-family: inherit;
  transition: border-color 0.15s, box-shadow 0.15s;
}

.calendario-operacional-day:hover {
  border-color: #004790;
  box-shadow: 0 2px 6px rgba(0, 71, 144, 0.12);
}

.calendario-operacional-day:focus-visible {
  outline: 2px solid #004790;
  outline-offset: 1px;
}

.calendario-operacional-day-numero {
  font-size: 14px;
  font-weight: 700;
  color: #111827;
}

.calendario-operacional-day-regime {
  display: inline-flex;
  align-items: center;
  padding: 2px 6px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.03em;
  width: fit-content;
}

.calendario-operacional-day--normal .calendario-operacional-day-regime {
  background: #dbeafe;
  color: #1e40af;
}

.calendario-operacional-day--plantao .calendario-operacional-day-regime {
  background: #fef3c7;
  color: #92400e;
}

/* Regime padrão (sem configuração específica) -> mais discreto */
.calendario-operacional-day:not(.calendario-operacional-day--especifica) .calendario-operacional-day-regime {
  opacity: 0.55;
}

/* Configuração específica -> destaque */
.calendario-operacional-day--especifica.calendario-operacional-day--normal {
  border-color: #2563eb;
  background: #eff6ff;
}

.calendario-operacional-day--especifica.calendario-operacional-day--plantao {
  border-color: #f59e0b;
  background: #fffbeb;
}

.calendario-operacional-day-marcador {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}

.calendario-operacional-day--especifica.calendario-operacional-day--normal .calendario-operacional-day-marcador {
  background: #2563eb;
}

.calendario-operacional-day--especifica.calendario-operacional-day--plantao .calendario-operacional-day-marcador {
  background: #f59e0b;
}

.calendario-operacional-day-observacao {
  font-size: 11px;
  color: #4b5563;
  line-height: 1.25;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  word-break: break-word;
}

@media (max-width: 640px) {
  .calendario-operacional-day {
    min-height: 60px;
    padding: 6px 8px;
    gap: 2px;
  }

  .calendario-operacional-day-numero {
    font-size: 13px;
  }

  .calendario-operacional-day-observacao {
    display: none;
  }
}
</style>
