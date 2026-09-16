<template>
  <div class="agenda-day-details">
    <h3 class="agenda-day-details-title">Resumo operacional</h3>

    <div class="agenda-day-details-body">
      <div class="agenda-day-details-item">
        <span class="agenda-day-details-label">Data</span>
        <span class="agenda-day-details-value">{{ dataFormatada }}</span>
      </div>

      <div class="agenda-day-details-item">
        <span class="agenda-day-details-label">Regime</span>
        <span class="agenda-day-details-value agenda-day-details-badge">{{ regimeExibido }}</span>
      </div>

      <div class="agenda-day-details-item">
        <span class="agenda-day-details-label">Atendimento</span>
        <span
          class="agenda-day-details-value"
          :class="{ 'agenda-day-details-value--inativo': diaAtivo === false }"
        >
          {{ atendimentoLabel }}
        </span>
      </div>

      <div class="agenda-day-details-item">
        <span class="agenda-day-details-label">Progresso</span>
        <span class="agenda-day-details-value">{{ progresso }}</span>
      </div>

      <div class="agenda-day-details-item">
        <span class="agenda-day-details-label">Situação atual</span>
        <span class="agenda-day-details-value">{{ situacaoAtual }}</span>
      </div>

      <div class="agenda-day-details-item">
        <span class="agenda-day-details-label">Pendências</span>
        <span
          class="agenda-day-details-value"
          :class="{ 'agenda-day-details-value--alerta': temPendencias }"
        >
          {{ pendencias }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { formatarDataExtensa } from '@/utils/reservas'

interface Props {
  data: string
  regime: string | null
  diaAtivo: boolean | null
  progresso: string
  situacaoAtual: string
  pendencias: string
  temPendencias: boolean
}

const props = defineProps<Props>()

const regimeExibido = computed(() => {
  if (!props.regime) {
    return '—'
  }
  return props.regime === 'PLANTAO' ? 'PLANTÃO' : props.regime
})

const atendimentoLabel = computed(() => {
  if (props.diaAtivo === false) {
    return 'Sem atendimento'
  }
  if (props.diaAtivo === true) {
    return 'Ativo'
  }
  return '—'
})

const dataFormatada = computed(() => {
  if (!props.data) {
    return '—'
  }
  return formatarDataExtensa(props.data)
})
</script>

<style scoped>
.agenda-day-details {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.agenda-day-details-title {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.agenda-day-details-body {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.agenda-day-details-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.agenda-day-details-item:not(:first-child) {
  padding-top: 12px;
  border-top: 1px dashed #e5e7eb;
}

.agenda-day-details-label {
  font-size: 12px;
  color: #6b7280;
}

.agenda-day-details-value {
  font-size: 13px;
  font-weight: 600;
  color: #111827;
}

.agenda-day-details-value--alerta {
  color: #b45309;
}

.agenda-day-details-value--inativo {
  align-self: flex-start;
  display: inline-flex;
  padding: 2px 10px;
  border-radius: 999px;
  background: #fee2e2;
  color: #991b1b;
  font-size: 12px;
  font-weight: 700;
}

.agenda-day-details-badge {
  align-self: flex-start;
  background: #dbeafe;
  color: #004790;
  padding: 2px 10px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
</style>
