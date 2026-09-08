<template>
  <span class="status-badge" :class="`status-badge--${badgeVariant}`">
    <span class="status-dot" />
    {{ label }}
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  status: string
}

const props = defineProps<Props>()

const statusMap: Record<string, { label: string; variant: string }> = {
  RESERVADA: { label: 'Reservada', variant: 'blue' },
  EM_LAVAGEM: { label: 'Em Lavagem', variant: 'amber' },
  CONCLUIDA: { label: 'Concluída', variant: 'green' },
  CANCELADA: { label: 'Cancelada', variant: 'red' },
  EXPIRADA: { label: 'Expirada', variant: 'gray' }
}

const badgeVariant = computed(() => statusMap[props.status]?.variant || 'gray')
const label = computed(() => statusMap[props.status]?.label || props.status)
</script>

<style scoped>
.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 12px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  width: fit-content;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}

.status-badge--blue { background: #dbeafe; color: #1e40af; }
.status-badge--amber { background: #fef3c7; color: #92400e; }
.status-badge--green { background: #d1fae5; color: #065f46; }
.status-badge--red { background: #fee2e2; color: #991b1b; }
.status-badge--gray { background: #f3f4f6; color: #4b5563; }
</style>