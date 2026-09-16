<template>
  <div class="reserva-detalhes-overlay" role="presentation">
    <div
      class="reserva-detalhes"
      role="dialog"
      aria-modal="true"
      aria-labelledby="reserva-detalhes-title"
    >
      <header class="reserva-detalhes-header">
        <div class="reserva-detalhes-header-text">
          <h2 id="reserva-detalhes-title" class="reserva-detalhes-title">Detalhes da Reserva</h2>
          <p class="reserva-detalhes-subtitle">
            {{ reserva.placa }} · {{ reserva.veiculo }}
          </p>
        </div>
        <button
          type="button"
          class="reserva-detalhes-close"
          aria-label="Fechar"
          @click="$emit('close')"
        >
          <XMarkIcon aria-hidden="true" />
        </button>
      </header>

      <div class="reserva-detalhes-body">
        <section class="reserva-detalhes-section">
          <h3 class="reserva-detalhes-section-title">Reserva</h3>
          <dl class="reserva-detalhes-grid">
            <div class="reserva-detalhes-item">
              <dt>Veículo</dt>
              <dd>{{ reserva.veiculo }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Placa</dt>
              <dd>{{ reserva.placa }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Tipo</dt>
              <dd>{{ reserva.tipo }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Modelo</dt>
              <dd>{{ reserva.modelo }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Solicitante</dt>
              <dd>{{ reserva.solicitante }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Matrícula</dt>
              <dd>{{ reserva.matricula }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Data</dt>
              <dd>{{ formatarDataCurta(reserva.data) }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Tempo estimado</dt>
              <dd>{{ reserva.tempoEstimado }} min</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Status</dt>
              <dd><AgendaStatusBadge :status="reserva.status" /></dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Início da lavagem</dt>
              <dd>{{ horarios.inicio ? formatarDataHora(horarios.inicio) : '—' }}</dd>
            </div>
            <div class="reserva-detalhes-item">
              <dt>Fim da lavagem</dt>
              <dd>{{ horarios.fim ? formatarDataHora(horarios.fim) : '—' }}</dd>
            </div>
            <div class="reserva-detalhes-item reserva-detalhes-item--full">
              <dt>Observação</dt>
              <dd>{{ reserva.observacao || '—' }}</dd>
            </div>
          </dl>
        </section>

        <section class="reserva-detalhes-section">
          <h3 class="reserva-detalhes-section-title">Histórico</h3>

          <div v-if="loading" class="reserva-detalhes-state">
            <span class="reserva-detalhes-spinner" aria-hidden="true" />
            <span>Carregando histórico...</span>
          </div>

          <p v-else-if="eventos.length === 0" class="reserva-detalhes-state reserva-detalhes-state--texto">
            Nenhum evento registrado para esta reserva.
          </p>

          <ol v-else class="reserva-detalhes-historico">
            <li v-for="evento in eventos" :key="evento.id" class="reserva-detalhes-evento">
              <div class="reserva-detalhes-evento-top">
                <span class="reserva-detalhes-evento-tipo">{{ labelTipoEvento(evento.tipo_evento) }}</span>
                <span class="reserva-detalhes-evento-data">{{ formatarDataHora(evento.created_at) }}</span>
              </div>
              <p class="reserva-detalhes-evento-status">{{ statusChange(evento) }}</p>
              <p v-if="labelMotivo(evento.motivo)" class="reserva-detalhes-evento-extra">
                Motivo: {{ labelMotivo(evento.motivo) }}
              </p>
              <p v-if="evento.observacao" class="reserva-detalhes-evento-extra">
                Observação: {{ evento.observacao }}
              </p>
            </li>
          </ol>
        </section>
      </div>

      <footer class="reserva-detalhes-footer">
        <button
          type="button"
          class="reserva-detalhes-btn reserva-detalhes-btn--secondary"
          @click="$emit('close')"
        >
          Fechar
        </button>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import AgendaStatusBadge from '@/components/agenda/AgendaStatusBadge.vue'
import { STATUS_LABELS } from '@/utils/reservas'
import {
  derivarHorarios,
  formatarDataCurta,
  formatarDataHora,
  labelMotivo,
  labelTipoEvento,
  type EventoReserva,
  type ReservaAdmin
} from '@/utils/reservasAdmin'

interface Props {
  reserva: ReservaAdmin
  eventos: EventoReserva[]
  loading: boolean
}

const props = defineProps<Props>()

defineEmits<{
  close: []
}>()

const horarios = computed(() => derivarHorarios(props.eventos))

const statusChange = (evento: EventoReserva): string => {
  const novo = STATUS_LABELS[evento.status_novo] ?? evento.status_novo

  if (!evento.status_anterior) {
    return `Status: ${novo}`
  }

  const anterior = STATUS_LABELS[evento.status_anterior] ?? evento.status_anterior
  return `${anterior} → ${novo}`
}
</script>

<style scoped>
.reserva-detalhes-overlay {
  position: fixed;
  inset: 0;
  background: rgba(17, 24, 39, 0.55);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.reserva-detalhes {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
  width: 100%;
  max-width: 720px;
  max-height: calc(100vh - 32px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.reserva-detalhes-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 28px 20px;
  border-bottom: 1px solid #e5e7eb;
}

.reserva-detalhes-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.reserva-detalhes-title {
  font-size: 20px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.reserva-detalhes-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

.reserva-detalhes-close {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border: none;
  background: transparent;
  border-radius: 8px;
  color: #6b7280;
  cursor: pointer;
  flex-shrink: 0;
}

.reserva-detalhes-close:hover {
  background: #f3f4f6;
  color: #111827;
}

.reserva-detalhes-close svg {
  width: 20px;
  height: 20px;
}

.reserva-detalhes-body {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.reserva-detalhes-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.reserva-detalhes-section-title {
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #6b7280;
  margin: 0;
  padding-bottom: 8px;
  border-bottom: 1px solid #e5e7eb;
}

.reserva-detalhes-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px 24px;
  margin: 0;
}

.reserva-detalhes-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.reserva-detalhes-item--full {
  grid-column: 1 / -1;
}

.reserva-detalhes-item dt {
  font-size: 12px;
  color: #6b7280;
}

.reserva-detalhes-item dd {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #1f2937;
}

.reserva-detalhes-state {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #6b7280;
  font-size: 14px;
}

.reserva-detalhes-state--texto {
  margin: 0;
}

.reserva-detalhes-spinner {
  width: 20px;
  height: 20px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: reserva-detalhes-spin 0.8s linear infinite;
}

@keyframes reserva-detalhes-spin {
  to {
    transform: rotate(360deg);
  }
}

.reserva-detalhes-historico {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.reserva-detalhes-evento {
  background: #f8fafc;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  padding: 12px 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.reserva-detalhes-evento-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}

.reserva-detalhes-evento-tipo {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
}

.reserva-detalhes-evento-data {
  font-size: 12px;
  color: #6b7280;
}

.reserva-detalhes-evento-status {
  margin: 0;
  font-size: 13px;
  color: #374151;
}

.reserva-detalhes-evento-extra {
  margin: 0;
  font-size: 13px;
  color: #6b7280;
}

.reserva-detalhes-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 28px 20px;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.reserva-detalhes-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 22px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
}

.reserva-detalhes-btn--secondary {
  background: #fff;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.reserva-detalhes-btn--secondary:hover {
  background: #f3f4f6;
}

@media (max-width: 600px) {
  .reserva-detalhes-overlay {
    padding: 8px;
    align-items: flex-end;
  }

  .reserva-detalhes {
    max-height: 92vh;
  }

  .reserva-detalhes-header {
    padding: 20px 20px 16px;
  }

  .reserva-detalhes-body {
    padding: 20px;
  }

  .reserva-detalhes-grid {
    grid-template-columns: 1fr;
  }

  .reserva-detalhes-footer {
    padding: 14px 20px 16px;
  }

  .reserva-detalhes-btn {
    width: 100%;
  }
}
</style>
