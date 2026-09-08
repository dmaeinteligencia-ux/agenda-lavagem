<template>
  <div class="usage-legend">
    <div class="legend-item">
      <span class="legend-dot legend-dot--utilizado" />
      <span class="legend-label">Utilizado</span>
      <span class="legend-value">{{ tempoUtilizado }} min</span>
    </div>
    <div class="legend-item">
      <span class="legend-dot legend-dot--disponivel" />
      <span class="legend-label">Disponível</span>
      <span class="legend-value">{{ disponivel }} min</span>
    </div>
    <div class="legend-item">
      <span class="legend-dot legend-dot--capacidade" />
      <span class="legend-label">Capacidade total</span>
      <span class="legend-value">{{ capacidadeTotal }} min</span>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  capacidadeTotal: number
  tempoUtilizado: number
  disponivel: number
}

defineProps<Props>()
</script>

<style scoped>
.usage-legend {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
}

.legend-dot {
  width: 12px;
  height: 12px;
  border-radius: 3px;
  flex-shrink: 0;
}

.legend-dot--utilizado { background: #004790; }
.legend-dot--disponivel { background: #e5e7eb; }
.legend-dot--capacidade { background: #9ca3af; border-radius: 50%; }

.legend-label { color: #6b7280; flex: 1; }
.legend-value { font-weight: 600; color: #111827; }
</style>