<template>
  <div class="agenda-usage">
    <div class="agenda-usage-header">
      <h3 class="agenda-usage-title">Utilização</h3>
    </div>
    <div class="agenda-usage-body">
      <div class="agenda-usage-donut">
        <svg viewBox="0 0 120 120" class="donut-svg">
          <circle cx="60" cy="60" r="50" fill="none" stroke="#e5e7eb" stroke-width="12" />
          <circle
            cx="60" cy="60" r="50"
            fill="none"
            stroke="#004790"
            stroke-width="12"
            stroke-linecap="round"
            :stroke-dasharray="circumference"
            :stroke-dashoffset="dashOffset"
            transform="rotate(-90 60 60)"
          />
          <text x="60" y="56" text-anchor="middle" class="donut-value">65%</text>
          <text x="60" y="76" text-anchor="middle" class="donut-label">utilizado</text>
        </svg>
      </div>
      <div class="agenda-usage-info">
        <div class="agenda-usage-row">
          <span class="agenda-usage-label">Capacidade total</span>
          <span class="agenda-usage-value">480 min</span>
        </div>
        <div class="agenda-usage-row">
          <span class="agenda-usage-label">Utilizado</span>
          <span class="agenda-usage-value">312 min</span>
        </div>
        <div class="agenda-usage-row">
          <span class="agenda-usage-label">Disponível</span>
          <span class="agenda-usage-value agenda-usage-value--accent">168 min</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const circumference = 2 * Math.PI * 50
const usedPercent = 65
const dashOffset = circumference - (usedPercent / 100) * circumference
</script>

<style scoped>
.agenda-usage {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.agenda-usage-title {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.agenda-usage-body {
  display: flex;
  align-items: center;
  gap: 20px;
}

.donut-svg {
  width: 120px;
  height: 120px;
  flex-shrink: 0;
}

.donut-value {
  font-size: 20px;
  font-weight: 700;
  fill: #111827;
}

.donut-label {
  font-size: 10px;
  fill: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.agenda-usage-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 0;
}

.agenda-usage-row {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  padding: 4px 0;
  border-bottom: 1px dashed #e5e7eb;
}

.agenda-usage-row:last-child {
  border-bottom: none;
}

.agenda-usage-label { color: #6b7280; }
.agenda-usage-value { font-weight: 600; color: #111827; }
.agenda-usage-value--accent { color: #004790; font-weight: 700; }
</style>