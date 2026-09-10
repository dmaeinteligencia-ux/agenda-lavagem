<template>
  <span
    class="jornada-lavador-status-badge"
    :class="disponivel ? 'jornada-lavador-status-badge--disponivel' : 'jornada-lavador-status-badge--indisponivel'"
  >
    <span class="jornada-lavador-status-dot" aria-hidden="true" />
    {{ label }}
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  disponivel: boolean
}

const props = defineProps<Props>()

const label = computed(() => (props.disponivel ? 'Disponível' : 'Indisponível'))
</script>

<style scoped>
.jornada-lavador-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.02em;
  width: fit-content;
  white-space: nowrap;
}

.jornada-lavador-status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}

.jornada-lavador-status-badge--disponivel {
  background: #d1fae5;
  color: #065f46;
}

.jornada-lavador-status-badge--disponivel .jornada-lavador-status-dot {
  background: #059669;
}

.jornada-lavador-status-badge--indisponivel {
  background: #fee2e2;
  color: #991b1b;
}

.jornada-lavador-status-badge--indisponivel .jornada-lavador-status-dot {
  background: #dc2626;
}
</style>
