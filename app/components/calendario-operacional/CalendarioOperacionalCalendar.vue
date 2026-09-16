<template>
  <div class="calendario-operacional-calendar">
    <div class="calendario-operacional-toolbar">
      <div class="calendario-operacional-nav">
        <button
          type="button"
          class="calendario-operacional-nav-btn"
          aria-label="Mês anterior"
          @click="mesAnterior"
        >
          <ChevronLeftIcon aria-hidden="true" />
        </button>
        <span class="calendario-operacional-titulo">{{ MESES[mes] }} {{ ano }}</span>
        <button
          type="button"
          class="calendario-operacional-nav-btn"
          aria-label="Próximo mês"
          @click="proximoMes"
        >
          <ChevronRightIcon aria-hidden="true" />
        </button>
      </div>
      <button type="button" class="calendario-operacional-hoje-btn" @click="irParaHoje">
        Hoje
      </button>
    </div>

    <div class="calendario-operacional-scroll">
      <div class="calendario-operacional-weekdays">
        <span v-for="dia in DIAS_SEMANA_ABREV" :key="dia" class="calendario-operacional-weekday">{{ dia }}</span>
      </div>

      <div class="calendario-operacional-grid">
        <template v-for="(celula, index) in celulas" :key="index">
          <div v-if="celula === null" class="calendario-operacional-cell calendario-operacional-cell--vazia" />
          <CalendarioOperacionalDay
            v-else
            :dia="celula.dia"
            :iso="celula.iso"
            :resolvido="celula.resolvido"
            :eh-hoje="celula.iso === hojeIso"
            @click="$emit('select-day', { data: celula.iso, resolvido: celula.resolvido })"
          />
        </template>
      </div>
    </div>

    <div class="calendario-operacional-legenda">
      <span class="calendario-operacional-legenda-item">
        <span class="calendario-operacional-legenda-dot calendario-operacional-legenda-dot--normal" aria-hidden="true" />
        NORMAL
      </span>
      <span class="calendario-operacional-legenda-item">
        <span class="calendario-operacional-legenda-dot calendario-operacional-legenda-dot--plantao" aria-hidden="true" />
        PLANTÃO
      </span>
      <span class="calendario-operacional-legenda-item">
        <span class="calendario-operacional-legenda-star" aria-hidden="true">★</span>
        Feriado oficial
      </span>
      <span class="calendario-operacional-legenda-item">
        <span class="calendario-operacional-legenda-dot calendario-operacional-legenda-dot--especifica" aria-hidden="true" />
        Configuração manual
      </span>
      <span class="calendario-operacional-legenda-item">
        <span class="calendario-operacional-legenda-dot calendario-operacional-legenda-dot--inativo" aria-hidden="true" />
        Sem atendimento
      </span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ChevronLeftIcon, ChevronRightIcon } from '@heroicons/vue/24/outline'
import CalendarioOperacionalDay from './CalendarioOperacionalDay.vue'
import {
  DIAS_SEMANA_ABREV,
  MESES,
  getDiasNoMes,
  getPrimeiroDiaDaSemana,
  hojeISO,
  resolverDia,
  toISODate,
  type CalendarioConfiguracao,
  type DiaOperacional,
  type FeriadoOficial
} from '@/utils/calendarioOperacional'

interface Props {
  ano: number
  mes: number
  configuracoes: CalendarioConfiguracao[]
  feriados: FeriadoOficial[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'change-month': [payload: { ano: number; mes: number }]
  'select-day': [payload: { data: string; resolvido: DiaOperacional }]
}>()

const hojeIso = hojeISO()

const configPorData = computed(() => {
  const mapa = new Map<string, CalendarioConfiguracao>()
  for (const config of props.configuracoes) {
    mapa.set(config.data, config)
  }
  return mapa
})

const feriadoPorData = computed(() => {
  const mapa = new Map<string, FeriadoOficial>()
  for (const feriado of props.feriados) {
    if (!mapa.has(feriado.data)) {
      mapa.set(feriado.data, feriado)
    }
  }
  return mapa
})

interface Celula {
  dia: number
  iso: string
  resolvido: DiaOperacional
}

const celulas = computed<Array<Celula | null>>(() => {
  const primeiro = getPrimeiroDiaDaSemana(props.ano, props.mes)
  const total = getDiasNoMes(props.ano, props.mes)
  const resultado: Array<Celula | null> = []

  for (let i = 0; i < primeiro; i++) {
    resultado.push(null)
  }

  for (let d = 1; d <= total; d++) {
    const iso = toISODate(props.ano, props.mes, d)
    resultado.push({
      dia: d,
      iso,
      resolvido: resolverDia(iso, feriadoPorData.value.get(iso) ?? null, configPorData.value.get(iso) ?? null)
    })
  }

  return resultado
})

const mesAnterior = () => {
  const mes = props.mes === 0 ? 11 : props.mes - 1
  const ano = props.mes === 0 ? props.ano - 1 : props.ano
  emit('change-month', { ano, mes })
}

const proximoMes = () => {
  const mes = props.mes === 11 ? 0 : props.mes + 1
  const ano = props.mes === 11 ? props.ano + 1 : props.ano
  emit('change-month', { ano, mes })
}

const irParaHoje = () => {
  const hoje = new Date()
  emit('change-month', { ano: hoje.getFullYear(), mes: hoje.getMonth() })
}
</script>

<style scoped>
.calendario-operacional-calendar {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  padding: 20px;
}

.calendario-operacional-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.calendario-operacional-nav {
  display: flex;
  align-items: center;
  gap: 8px;
}

.calendario-operacional-titulo {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  min-width: 140px;
  text-align: center;
}

.calendario-operacional-nav-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #fff;
  color: #374151;
  cursor: pointer;
  transition: background-color 0.15s, border-color 0.15s;
}

.calendario-operacional-nav-btn:hover {
  background: #f9fafb;
  border-color: #d1d5db;
}

.calendario-operacional-nav-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.calendario-operacional-nav-btn svg {
  width: 18px;
  height: 18px;
}

.calendario-operacional-hoje-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  font-size: 13px;
  font-weight: 600;
  color: #004790;
  background: #fff;
  border: 1px solid #004790;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.15s;
}

.calendario-operacional-hoje-btn:hover {
  background: #e8f0fe;
}

.calendario-operacional-hoje-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.calendario-operacional-scroll {
  overflow-x: auto;
}

.calendario-operacional-weekdays {
  display: grid;
  grid-template-columns: repeat(7, minmax(0, 1fr));
  gap: 6px;
  min-width: 560px;
  margin-bottom: 6px;
}

.calendario-operacional-weekday {
  text-align: center;
  font-size: 11px;
  font-weight: 700;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  padding: 4px 0;
}

.calendario-operacional-grid {
  display: grid;
  grid-template-columns: repeat(7, minmax(0, 1fr));
  gap: 6px;
  min-width: 560px;
}

.calendario-operacional-cell--vazia {
  min-height: 96px;
  border-radius: 8px;
  background: #f9fafb;
  border: 1px dashed #e5e7eb;
}

.calendario-operacional-legenda {
  display: flex;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
  margin-top: 16px;
  padding-top: 14px;
  border-top: 1px solid #f1f5f9;
}

.calendario-operacional-legenda-item {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #4b5563;
}

.calendario-operacional-legenda-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}

.calendario-operacional-legenda-dot--normal {
  background: #60a5fa;
}

.calendario-operacional-legenda-dot--plantao {
  background: #f59e0b;
}

.calendario-operacional-legenda-dot--especifica {
  width: 8px;
  height: 8px;
  border: 2px solid #2563eb;
  background: transparent;
}

.calendario-operacional-legenda-dot--inativo {
  background: #ef4444;
}

.calendario-operacional-legenda-star {
  color: #f59e0b;
  font-size: 12px;
}

@media (max-width: 640px) {
  .calendario-operacional-calendar {
    padding: 14px;
  }

  .calendario-operacional-titulo {
    min-width: 120px;
  }

  .calendario-operacional-cell--vazia {
    min-height: 60px;
  }
}
</style>
