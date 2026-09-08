<template>
  <div class="usage-donut">
    <svg viewBox="0 0 120 120" class="donut-svg">
      <circle
        class="donut-bg"
        cx="60" cy="60" r="50"
        fill="none"
        stroke="#e5e7eb"
        stroke-width="12"
      />
      <circle
        class="donut-segment"
        cx="60" cy="60" r="50"
        fill="none"
        :stroke="segmentColor"
        stroke-width="12"
        stroke-linecap="round"
        :stroke-dasharray="donutDash"
        :stroke-dashoffset="donutOffset"
        transform="rotate(-90 60 60)"
      />
      <text x="60" y="56" text-anchor="middle" class="donut-value">{{ percentual }}%</text>
      <text x="60" y="76" text-anchor="middle" class="donut-label">uso</text>
    </svg>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  percentual: number
}

const props = defineProps<Props>()

const clamped = computed(() => Math.min(100, Math.max(0, props.percentual)))

const segmentColor = computed(() => {
  if (clamped.value > 75) return '#f59e0b'
  if (clamped.value > 50) return '#004790'
  if (clamped.value > 25) return '#3b82f6'
  return '#22c55e'
})

const CIRCUMFERENCE = 2 * Math.PI * 50

const donutDash = computed(() => `${CIRCUMFERENCE}`)

const donutOffset = computed(() => {
  const filled = (clamped.value / 100) * CIRCUMFERENCE
  return CIRCUMFERENCE - filled
})
</script>

<style scoped>
.donut-svg {
  width: 140px;
  height: 140px;
}

.donut-bg {
  stroke: #e5e7eb;
}

.donut-value {
  font-size: 22px;
  font-weight: 700;
  fill: #111827;
}

.donut-label {
  font-size: 10px;
  fill: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
</style>