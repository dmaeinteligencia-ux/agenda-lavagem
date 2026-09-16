<template>
  <div class="agenda-available-slot">
    <span class="agenda-available-slot-label">{{ label }}</span>
  </div>
</template>

<script setup lang="ts">
interface Props {
  label: string
}

defineProps<Props>()
</script>

<style scoped>
.agenda-available-slot {
  display: flex;
  align-items: center;
  gap: 8px;
  background: #f0f9ff;
  border: 1px dashed #bae6fd;
  border-radius: 8px;
  padding: 10px 14px;
  color: #0369a1;
  font-size: 13px;
  font-weight: 500;
}

.agenda-available-slot-label {
  font-weight: 600;
  color: #0284c7;
  font-size: 12px;
  margin-left: auto;
  margin-right: auto;
}
</style>
