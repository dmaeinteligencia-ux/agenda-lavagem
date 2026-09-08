<template>
  <button class="quick-action" @click="$emit('click')">
    <div class="quick-action-icon">
      <component :is="icon" aria-hidden="true" />
    </div>
    <div class="quick-action-info">
      <span class="quick-action-title">{{ title }}</span>
      <span class="quick-action-desc">{{ description }}</span>
    </div>
  </button>
</template>

<script setup lang="ts">
import type { Component } from 'vue'

interface Props {
  title: string
  description: string
  icon: Component
}

defineProps<Props>()
defineEmits<{
  click: []
}>()
</script>

<style scoped>
.quick-action {
  display: flex;
  align-items: center;
  gap: 14px;
  width: 100%;
  padding: 16px 20px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  text-align: left;
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.quick-action:hover {
  border-color: #004790;
  box-shadow: 0 4px 12px rgba(0, 71, 144, 0.08);
}

.quick-action-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: #dbeafe;
  color: #004790;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.quick-action-icon svg {
  width: 24px;
  height: 24px;
}

.quick-action-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.quick-action-title {
  font-weight: 600;
  color: #111827;
  font-size: 14px;
}

.quick-action-desc {
  font-size: 12px;
  color: #6b7280;
}
</style>