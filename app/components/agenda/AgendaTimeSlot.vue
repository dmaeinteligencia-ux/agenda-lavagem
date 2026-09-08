<template>
  <div class="agenda-time-slot">
    <span class="agenda-time-slot-time">{{ time }}</span>
  </div>
</template>

<script setup lang="ts">
interface Props {
  time: string
}

defineProps<Props>()
</script>

<style scoped>
.agenda-time-slot {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding-right: 16px;
  position: relative;
  width: 70px;
  flex-shrink: 0;
}

.agenda-time-slot-time {
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  z-index: 1;
  background: #f5f7fa;
  padding: 0 6px;
}
</style>