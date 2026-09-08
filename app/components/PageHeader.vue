<template>
  <header class="page-header">
    <div class="page-header-text">
      <h1 class="page-header-title">{{ title }}</h1>
      <p v-if="subtitle" class="page-header-subtitle">{{ subtitle }}</p>
    </div>
    <DateInfo :weekday="weekday" :date="date" />
  </header>
</template>

<script setup lang="ts">
import DateInfo from './DateInfo.vue'

interface Props {
  title: string
  subtitle?: string
  weekday: string
  date: string
}

defineProps<Props>()
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 24px;
  gap: 16px;
  flex-wrap: wrap;
}

.page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

@media (max-width: 600px) {
  .page-header {
    margin-bottom: 16px;
  }

  .page-header-title {
    font-size: 20px;
  }

  .page-header-subtitle {
    font-size: 13px;
  }
}
</style>