<template>
  <div class="agenda-summary-card">
    <div class="agenda-summary-card-icon" :class="`agenda-summary-card-icon--${variant}`">
      <component :is="icon" aria-hidden="true" />
    </div>
    <div class="agenda-summary-card-body">
      <span class="agenda-summary-card-title">{{ title }}</span>
      <span
        class="agenda-summary-card-value"
        :class="{ 'agenda-summary-card-value--compact': compactValue }"
      >{{ value }}</span>
      <span class="agenda-summary-card-desc">{{ description }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Component } from 'vue'

interface Props {
  title: string
  value: string
  description: string
  icon: Component
  variant?: 'blue' | 'green' | 'amber' | 'red'
  compactValue?: boolean
}

withDefaults(defineProps<Props>(), {
  variant: 'blue',
  compactValue: false
})
</script>

<style scoped>
.agenda-summary-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  display: flex;
  align-items: center;
  gap: 14px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  border: 1px solid #e5e7eb;
}

.agenda-summary-card-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.agenda-summary-card-icon svg {
  width: 22px;
  height: 22px;
}

.agenda-summary-card-icon--blue { background: #dbeafe; color: #004790; }
.agenda-summary-card-icon--green { background: #d1fae5; color: #065f46; }
.agenda-summary-card-icon--amber { background: #fef3c7; color: #92400e; }
.agenda-summary-card-icon--red { background: #fee2e2; color: #991b1b; }

.agenda-summary-card-body {
  display: flex;
  flex-direction: column;
  line-height: 1.3;
}

.agenda-summary-card-title {
  font-size: 12px;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.agenda-summary-card-value {
  font-size: 22px;
  font-weight: 700;
  color: #111827;
}

.agenda-summary-card-value--compact {
  font-size: 14px;
  line-height: 1.3;
}

.agenda-summary-card-desc {
  font-size: 12px;
  color: #9ca3af;
}
</style>