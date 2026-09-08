<template>
  <div class="summary-card">
    <div class="summary-card-icon" :class="`summary-card-icon--${variant}`">
      <component :is="icon" class="icon" aria-hidden="true" />
    </div>
    <div class="summary-card-body">
      <span class="summary-card-title">{{ title }}</span>
      <span class="summary-card-value">{{ value }}</span>
      <span class="summary-card-desc">{{ description }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Component } from 'vue'

interface Props {
  title: string
  value: string | number
  description: string
  icon: Component
  variant?: 'blue' | 'green' | 'amber' | 'red'
}

withDefaults(defineProps<Props>(), {
  variant: 'blue'
})
</script>

<style scoped>
.summary-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  display: flex;
  align-items: center;
  gap: 14px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  border: 1px solid #e5e7eb;
}

.summary-card-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.summary-card-icon svg {
  width: 22px;
  height: 22px;
}

.summary-card-icon--blue {
  background: #dbeafe;
  color: #004790;
}

.summary-card-icon--green {
  background: #d1fae5;
  color: #065f46;
}

.summary-card-icon--amber {
  background: #fef3c7;
  color: #92400e;
}

.summary-card-icon--red {
  background: #fee2e2;
  color: #991b1b;
}

.summary-card-body {
  display: flex;
  flex-direction: column;
  line-height: 1.3;
}

.summary-card-title {
  font-size: 12px;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.summary-card-value {
  font-size: 22px;
  font-weight: 700;
  color: #111827;
}

.summary-card-desc {
  font-size: 12px;
  color: #9ca3af;
}
</style>