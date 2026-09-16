<template>
  <span class="agenda-status-badge" :class="`agenda-status-badge--${badgeVariant}`">
    <span class="agenda-status-dot" />
    {{ label }}
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { STATUS_LABELS, type ReservaStatus } from '@/utils/reservas'

interface Props {
  status: ReservaStatus
}

const props = defineProps<Props>()

const statusMap: Record<ReservaStatus, { label: string; variant: string }> = {
  RESERVADA: { label: 'Reservada', variant: 'blue' },
  EM_LAVAGEM: { label: 'Em lavagem', variant: 'amber' },
  CONCLUIDA: { label: 'Concluída', variant: 'green' },
  CANCELADA: { label: 'Cancelada', variant: 'red' },
  EXPIRADA: { label: 'Expirada', variant: 'gray' },
  NAO_COMPARECEU: { label: 'Não compareceu', variant: 'orange' },
  NAO_ATENDIDA: { label: 'Não atendida', variant: 'purple' },
  NAO_CONCLUIDA: { label: 'Não concluída', variant: 'rose' }
}

const badgeVariant = computed(() => statusMap[props.status]?.variant || 'gray')
const label = computed(() => STATUS_LABELS[props.status] ?? statusMap[props.status]?.label ?? props.status)
</script>

<style scoped>
.agenda-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 12px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  width: fit-content;
}

.agenda-status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}

.agenda-status-badge--blue { background: #dbeafe; color: #1e40af; }
.agenda-status-badge--amber { background: #fef3c7; color: #92400e; }
.agenda-status-badge--green { background: #d1fae5; color: #065f46; }
.agenda-status-badge--red { background: #fee2e2; color: #991b1b; }
.agenda-status-badge--gray { background: #f3f4f6; color: #4b5563; }
.agenda-status-badge--orange { background: #ffedd5; color: #9a3412; }
.agenda-status-badge--purple { background: #ede9fe; color: #5b21b6; }
.agenda-status-badge--rose { background: #ffe4e6; color: #9f1239; }

.agenda-status-badge--blue .agenda-status-dot { background: #2563eb; }
.agenda-status-badge--amber .agenda-status-dot { background: #d97706; }
.agenda-status-badge--green .agenda-status-dot { background: #059669; }
.agenda-status-badge--red .agenda-status-dot { background: #dc2626; }
.agenda-status-badge--gray .agenda-status-dot { background: #9ca3af; }
.agenda-status-badge--orange .agenda-status-dot { background: #ea580c; }
.agenda-status-badge--purple .agenda-status-dot { background: #7c3aed; }
.agenda-status-badge--rose .agenda-status-dot { background: #e11d48; }
</style>
