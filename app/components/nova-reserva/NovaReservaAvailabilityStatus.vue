<template>
  <div class="nova-reserva-availability-status" :class="`nova-reserva-availability-status--${variant}`">
    <span class="nova-reserva-availability-status-dot" aria-hidden="true" />
    <span>{{ label }}</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  status: 'Disponível' | 'Indisponível'
}

const props = defineProps<Props>()

const label = computed(() =>
  props.status === 'Disponível' ? 'Disponível para reserva' : 'Indisponível'
)

const variant = computed(() => (props.status === 'Disponível' ? 'ok' : 'blocked'))
</script>

<style scoped>
.nova-reserva-availability-status {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 14px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  width: fit-content;
}

.nova-reserva-availability-status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}

.nova-reserva-availability-status--ok {
  background: #d1fae5;
  color: #065f46;
}

.nova-reserva-availability-status--ok .nova-reserva-availability-status-dot {
  background: #059669;
}

.nova-reserva-availability-status--blocked {
  background: #fee2e2;
  color: #991b1b;
}

.nova-reserva-availability-status--blocked .nova-reserva-availability-status-dot {
  background: #dc2626;
}
</style>