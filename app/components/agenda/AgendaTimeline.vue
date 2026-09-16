<template>
  <div class="agenda-timeline">
    <div class="agenda-timeline-header">
      <h3 class="agenda-timeline-title">Agenda do Dia</h3>
      <span class="agenda-timeline-regime">{{ regimeExibido }}</span>
    </div>
    <div class="agenda-timeline-body">
      <p v-if="items.length === 0" class="agenda-timeline-empty-text">
        Não há reservas para esta data.
      </p>

      <template v-else>
        <div
          v-for="item in items"
          :key="item.id"
          class="agenda-timeline-row"
        >
          <AgendaTimeSlot :time="item.inicioLavagem || '—'" />
          <div class="agenda-timeline-content">
            <AgendaReservationBlock
              :vehicle="item.vehicle"
              :plate="item.plate"
              :type="item.type"
              :status="item.status"
              :duration="item.duration"
              :solicitante="item.solicitante"
              :inicio-lavagem="item.inicioLavagem"
              :fim-lavagem="item.fimLavagem"
              :perfil="perfil"
              :tem-acesso="temAcesso"
              :loading="actionLoadingId === item.id"
              @acao="$emit('acao', $event, item)"
            />
          </div>
        </div>

        <div v-if="disponivelMinutos !== null" class="agenda-timeline-row">
          <AgendaTimeSlot time="—" />
          <div class="agenda-timeline-content">
            <AgendaAvailableSlot :label="`${disponivelMinutos} min disponíveis`" />
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import AgendaTimeSlot from './AgendaTimeSlot.vue'
import AgendaReservationBlock from './AgendaReservationBlock.vue'
import AgendaAvailableSlot from './AgendaAvailableSlot.vue'
import type { AcaoChave, AgendaReservaItem, Perfil } from '@/utils/reservas'

interface Props {
  items: AgendaReservaItem[]
  regime: string | null
  disponivelMinutos: number | null
  perfil: Perfil | null
  temAcesso: boolean
  actionLoadingId: string | null
}

const props = defineProps<Props>()

defineEmits<{
  acao: [chave: AcaoChave, item: AgendaReservaItem]
}>()

const regimeExibido = computed(() => {
  if (!props.regime) {
    return '—'
  }
  return props.regime === 'PLANTAO' ? 'PLANTÃO' : props.regime
})
</script>

<style scoped>
.agenda-timeline {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.agenda-timeline-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.agenda-timeline-title {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.agenda-timeline-regime {
  font-size: 12px;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 999px;
  background: #dbeafe;
  color: #004790;
}

.agenda-timeline-body {
  display: flex;
  flex-direction: column;
  position: relative;
}

.agenda-timeline-empty-text {
  margin: 0;
  padding: 24px 16px;
  color: #6b7280;
  font-size: 14px;
  text-align: center;
}

.agenda-timeline-row {
  display: flex;
  align-items: stretch;
  min-height: 48px;
  position: relative;
}

.agenda-timeline-row:not(:last-child)::before {
  content: '';
  position: absolute;
  left: 70px;
  top: 0;
  bottom: -1px;
  width: 1px;
  background: #e5e7eb;
}

.agenda-timeline-row::after {
  content: '';
  position: absolute;
  left: 60px;
  top: 50%;
  width: 20px;
  height: 1px;
  background: #e5e7eb;
}

.agenda-timeline-content {
  flex: 1;
  padding: 6px 0 6px 16px;
  display: flex;
  align-items: center;
}

.agenda-timeline-empty {
  width: 100%;
  min-height: 24px;
}
</style>
