<template>
  <div class="utilizacao-card">
    <div class="utilizacao-header">
      <h2 class="utilizacao-title">Utilização do Lavador</h2>
      <span class="utilizacao-regime">{{ regime }}</span>
    </div>
    <div class="utilizacao-body">
      <UsageDonut :percentual="percentualUtilizado" />
      <div class="utilizacao-detail">
        <UsageLegend
          :capacidade-total="capacidadeTotal"
          :tempo-utilizado="tempoUtilizado"
          :disponivel="disponivel"
        />
        <CapacityInfo
          :regime="regime"
          :capacidade-total="capacidadeTotal"
          :tempo-utilizado="tempoUtilizado"
          :disponivel="disponivel"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import UsageDonut from './UsageDonut.vue'
import UsageLegend from './UsageLegend.vue'
import CapacityInfo from './CapacityInfo.vue'

interface Props {
  regime: string
  capacidadeTotal: number
  tempoUtilizado: number
  disponivel: number
  percentualUtilizado: number
}

defineProps<Props>()
</script>

<style scoped>
.utilizacao-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  height: 100%;
  display: flex;
  flex-direction: column;
}

.utilizacao-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.utilizacao-title {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.utilizacao-regime {
  font-size: 12px;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 999px;
  background: #dbeafe;
  color: #004790;
}

.utilizacao-body {
  display: flex;
  gap: 24px;
  align-items: center;
  flex: 1;
}

.utilizacao-detail {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
  min-width: 0;
}

@media (max-width: 600px) {
  .utilizacao-body {
    flex-direction: column;
  }
}
</style>