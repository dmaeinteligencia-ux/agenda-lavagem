<template>
  <div class="agenda-page">
    <AgendaPageHeader />
    <AgendaFilters />
    <AgendaSummary />
    <div class="agenda-main-grid">
      <div class="agenda-main-left">
        <AgendaTimeline />
      </div>
      <div class="agenda-main-right">
        <AgendaDayDetails />
        <AgendaNewReservationButton />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import AgendaPageHeader from '@/components/agenda/AgendaPageHeader.vue'
import AgendaFilters from '@/components/agenda/AgendaFilters.vue'
import AgendaSummary from '@/components/agenda/AgendaSummary.vue'
import AgendaTimeline from '@/components/agenda/AgendaTimeline.vue'
import AgendaDayDetails from '@/components/agenda/AgendaDayDetails.vue'
import AgendaNewReservationButton from '@/components/agenda/AgendaNewReservationButton.vue'

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.agenda-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.agenda-main-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
}

.agenda-main-left {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.agenda-main-right {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

@media (max-width: 1024px) {
  .agenda-main-grid {
    grid-template-columns: 1fr;
  }

  .agenda-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .agenda-page {
    padding: 16px 12px;
    gap: 16px;
  }
}
</style>