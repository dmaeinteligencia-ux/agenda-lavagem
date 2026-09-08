<template>
  <div class="capacity-info">
    <div class="capacity-row">
      <span class="capacity-label">Regime</span>
      <span class="capacity-value">{{ regime }}</span>
    </div>
    <div class="capacity-row">
      <span class="capacity-label">Capacidade</span>
      <span class="capacity-value">{{ capacidadeTotal }} min</span>
    </div>
    <div class="capacity-row">
      <span class="capacity-label">Utilizado</span>
      <span class="capacity-value">{{ tempoUtilizado }} min</span>
    </div>
    <div class="capacity-row">
      <span class="capacity-label">Disponível</span>
      <span class="capacity-value capacity-value--accent">{{ disponivel }} min</span>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  regime: string
  capacidadeTotal: number
  tempoUtilizado: number
  disponivel: number
}

defineProps<Props>()
</script>

<style scoped>
.capacity-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.capacity-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  padding: 6px 0;
  border-bottom: 1px dashed #e5e7eb;
}

.capacity-label { color: #6b7280; }
.capacity-value { font-weight: 600; color: #111827; }
.capacity-value--accent { color: #004790; font-weight: 700; }
</style>