<template>
  <button
    type="button"
    class="calendario-operacional-day"
    :class="[
      `calendario-operacional-day--${resolvido.regime.toLowerCase()}`,
      {
        'calendario-operacional-day--especifica': !!resolvido.configuracao,
        'calendario-operacional-day--feriado': !!resolvido.feriado,
        'calendario-operacional-day--inativo': !resolvido.ativo
      }
    ]"
    :aria-label="ariaLabel"
    @click="$emit('click')"
  >
    <span class="calendario-operacional-day-top">
      <span class="calendario-operacional-day-numero-wrap">
        <span
          class="calendario-operacional-day-numero"
          :class="{ 'calendario-operacional-day-numero--hoje': ehHoje }"
        >{{ dia }}</span>
        <span v-if="ehHoje" class="calendario-operacional-day-hoje">Hoje</span>
      </span>
      <span v-if="resolvido.configuracao" class="calendario-operacional-day-marcador" aria-hidden="true" />
    </span>
    <span class="calendario-operacional-day-regime">{{ regimeLabel }}</span>
    <span v-if="!resolvido.ativo" class="calendario-operacional-day-inativo">Sem atendimento</span>
    <span v-if="contexto" class="calendario-operacional-day-observacao">{{ contexto }}</span>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { contextoDia, type DiaOperacional } from '@/utils/calendarioOperacional'

interface Props {
  dia: number
  iso: string
  resolvido: DiaOperacional
  ehHoje?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  ehHoje: false
})

defineEmits<{
  click: []
}>()

const regimeLabel = computed(() => (props.resolvido.regime === 'PLANTAO' ? 'PLANTÃO' : 'NORMAL'))

const contexto = computed(() => contextoDia(props.resolvido))

const ariaLabel = computed(() => {
  const partes = [`${props.dia}`, regimeLabel.value]
  if (props.ehHoje) {
    partes.push('Hoje')
  }
  if (!props.resolvido.ativo) {
    partes.push('Sem atendimento')
  }
  if (contexto.value) {
    partes.push(contexto.value)
  }
  return partes.join(', ')
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

.calendario-operacional-day-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}

.calendario-operacional-day-numero {
  font-size: 14px;
  font-weight: 700;
  color: #111827;
}

.calendario-operacional-day-numero-wrap {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  min-width: 0;
}

/* Dia atual: shape + peso + label (não depende só de cor) */
.calendario-operacional-day-numero--hoje {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 24px;
  height: 24px;
  padding: 0 5px;
  border-radius: 999px;
  background: #004790;
  color: #fff;
  font-weight: 800;
}

.calendario-operacional-day-hoje {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #004790;
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

.calendario-operacional-day--inativo {
  background: #fef2f2;
  border-color: #fecaca;
}

.calendario-operacional-day-inativo {
  display: inline-flex;
  align-items: center;
  padding: 2px 6px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 700;
  background: #fee2e2;
  color: #991b1b;
  width: fit-content;
}

.calendario-operacional-day--especifica {
  box-shadow: inset 0 0 0 1px rgba(37, 99, 235, 0.25);
}

.calendario-operacional-day--feriado .calendario-operacional-day-numero::after {
  content: '★';
  margin-left: 4px;
  color: #f59e0b;
  font-size: 11px;
}

.calendario-operacional-day-marcador {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
  background: #2563eb;
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
