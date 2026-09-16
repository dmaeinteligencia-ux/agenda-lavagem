<template>
  <div class="agenda-reservation-block" :class="`agenda-reservation-block--${statusVariant}`">
    <div class="agenda-reservation-block-content">
      <div class="agenda-reservation-block-top">
        <span class="agenda-reservation-block-veiculo">{{ vehicle }}</span>
        <AgendaStatusBadge :status="status" />
      </div>
      <div class="agenda-reservation-block-info">
        <span class="agenda-reservation-block-placa">{{ plate }}</span>
        <span class="agenda-reservation-block-type">{{ type }}</span>
        <span class="agenda-reservation-block-solicitante">{{ solicitante }}</span>
      </div>
      <div class="agenda-reservation-block-time">
        <span>{{ horarioTexto || '—' }}</span>
        <span class="agenda-reservation-block-duration">{{ duration }} min</span>
      </div>

      <AgendaReservationActions
        v-if="temAcesso && perfil"
        :status="status"
        :perfil="perfil"
        :tem-acesso="temAcesso"
        :loading="loading"
        @acao="$emit('acao', $event)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import AgendaStatusBadge from './AgendaStatusBadge.vue'
import AgendaReservationActions from './AgendaReservationActions.vue'
import type { Perfil, ReservaStatus } from '@/utils/reservas'

interface Props {
  vehicle: string
  plate: string
  type: string
  status: ReservaStatus
  duration: number
  solicitante: string
  inicioLavagem: string | null
  fimLavagem: string | null
  perfil: Perfil | null
  temAcesso: boolean
  loading: boolean
}

const props = defineProps<Props>()

defineEmits<{
  acao: [chave: string]
}>()

const statusVariant = computed(() => {
  if (props.status === 'EM_LAVAGEM') return 'lavagem'
  if (props.status === 'CONCLUIDA') return 'concluida'
  return 'reservada'
})

const horarioTexto = computed(() => {
  if (props.inicioLavagem && props.fimLavagem) {
    return `${props.inicioLavagem} — ${props.fimLavagem}`
  }
  if (props.inicioLavagem) {
    return `Iniciada às ${props.inicioLavagem}`
  }
  return null
})
</script>

<style scoped>
.agenda-reservation-block {
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-left-width: 4px;
  border-radius: 8px;
  padding: 12px 14px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
}

.agenda-reservation-block--reservada {
  border-left-color: #004790;
}

.agenda-reservation-block--lavagem {
  border-left-color: #f59e0b;
  background: #fffbeb;
}

.agenda-reservation-block--concluida {
  border-left-color: #10b981;
}

.agenda-reservation-block-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
}

.agenda-reservation-block-veiculo {
  font-weight: 700;
  color: #111827;
  font-size: 14px;
}

.agenda-reservation-block-info {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.agenda-reservation-block-placa {
  font-size: 12px;
  color: #6b7280;
  font-weight: 500;
  background: #f3f4f6;
  padding: 2px 8px;
  border-radius: 4px;
}

.agenda-reservation-block-type {
  font-size: 12px;
  color: #6b7280;
}

.agenda-reservation-block-solicitante {
  font-size: 12px;
  color: #6b7280;
}

.agenda-reservation-block-time {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 13px;
  font-weight: 600;
  color: #1f2937;
}

.agenda-reservation-block-duration {
  font-weight: 500;
  color: #6b7280;
  font-size: 12px;
}
</style>
