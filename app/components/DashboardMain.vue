<template>
  <main class="dashboard-main">
    <PageHeader
      title="Dashboard"
      subtitle="Visão geral do lavador"
      weekday="Quarta-feira"
      date="27/08/2026"
    />
    <SummaryCards />
    <DashboardContent />
    <QuickActions />
  </main>
</template>

<script setup lang="ts">
import PageHeader from './PageHeader.vue'
import SummaryCards from './SummaryCards.vue'
import DashboardContent from './DashboardContent.vue'
import QuickActions from './QuickActions.vue'
</script>

<style scoped>
.dashboard-main {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

@media (max-width: 1024px) {
  .dashboard-main {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .dashboard-main {
    padding: 16px 12px;
  }
}
</style>