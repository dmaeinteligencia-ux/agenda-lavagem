<template>
  <span class="status-badge" :class="`status-badge--${statusClass}`">
    <span class="status-dot" aria-hidden="true" />
    {{ label }}
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  status: 'PENDENTE' | 'ATIVO' | 'BLOQUEADO'
}

const props = defineProps<Props>()

const labels: Record<string, string> = {
  PENDENTE: 'Pendente',
  ATIVO: 'Ativo',
  BLOQUEADO: 'Bloqueado'
}

const label = computed(() => labels[props.status] ?? props.status)

const statusClass = computed(() => {
  switch (props.status) {
    case 'ATIVO':
      return 'ativo'
    case 'BLOQUEADO':
      return 'bloqueado'
    default:
      return 'pendente'
  }
})
</script>

<style scoped>
.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
}

.status-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  flex-shrink: 0;
}

.status-badge--ativo {
  background: #dcfce7;
  color: #166534;
}

.status-badge--ativo .status-dot {
  background: #16a34a;
}

.status-badge--pendente {
  background: #fef3c7;
  color: #92400e;
}

.status-badge--pendente .status-dot {
  background: #d97706;
}

.status-badge--bloqueado {
  background: #fee2e2;
  color: #991b1b;
}

.status-badge--bloqueado .status-dot {
  background: #dc2626;
}
</style>
