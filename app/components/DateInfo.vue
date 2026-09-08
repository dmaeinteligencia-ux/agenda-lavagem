<template>
  <div class="date-info">
    <span class="date-info-day">{{ weekday }}</span>
    <span class="date-info-date">{{ date }}</span>
  </div>
</template>

<script setup lang="ts">
interface Props {
  weekday: string
  date: string
}

defineProps<Props>()
</script>

<style scoped>
.date-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  line-height: 1.2;
}

.date-info-day {
  font-size: 13px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #6b7280;
}

.date-info-date {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
}
</style>