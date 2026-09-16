<template>
  <span class="veiculo-status-badge" :class="`veiculo-status-badge--${ativo ? 'ativo' : 'inativo'}`">
    <span class="veiculo-status-dot" aria-hidden="true" />
    {{ ativo ? 'Ativo' : 'Inativo' }}
  </span>
</template>

<script setup lang="ts">
interface Props {
  ativo: boolean
}

defineProps<Props>()
</script>

<style scoped>
.veiculo-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.02em;
  width: fit-content;
}

.veiculo-status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}

.veiculo-status-badge--ativo {
  background: #d1fae5;
  color: #065f46;
}

.veiculo-status-badge--ativo .veiculo-status-dot {
  background: #059669;
}

.veiculo-status-badge--inativo {
  background: #f3f4f6;
  color: #4b5563;
}

.veiculo-status-badge--inativo .veiculo-status-dot {
  background: #9ca3af;
}
</style>
