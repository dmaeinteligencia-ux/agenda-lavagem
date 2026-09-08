<template>
  <div class="agenda-day-details">
    <h3 class="agenda-day-details-title">Detalhes do dia</h3>
    <div class="agenda-day-details-body">
      <div class="agenda-day-details-row">
        <span class="agenda-day-details-label">Regime</span>
        <span class="agenda-day-details-value agenda-day-details-badge">PLANTÃO</span>
      </div>
      <div class="agenda-day-details-row">
        <span class="agenda-day-details-label">Capacidade</span>
        <span class="agenda-day-details-value">480 min</span>
      </div>
      <div class="agenda-day-details-row">
        <span class="agenda-day-details-label">Utilizado</span>
        <span class="agenda-day-details-value">312 min</span>
      </div>
      <div class="agenda-day-details-row">
        <span class="agenda-day-details-label">Disponível</span>
        <span class="agenda-day-details-value agenda-day-details-value--accent">168 min</span>
      </div>
      <div class="agenda-day-details-row">
        <span class="agenda-day-details-label">Reservas</span>
        <span class="agenda-day-details-value">4</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.agenda-day-details {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.agenda-day-details-title {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.agenda-day-details-body {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.agenda-day-details-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  padding: 6px 0;
  border-bottom: 1px dashed #e5e7eb;
}

.agenda-day-details-row:last-child {
  border-bottom: none;
}

.agenda-day-details-label { color: #6b7280; }
.agenda-day-details-value { font-weight: 600; color: #111827; }
.agenda-day-details-value--accent { color: #004790; font-weight: 700; }

.agenda-day-details-badge {
  background: #dbeafe;
  color: #004790;
  padding: 2px 10px;
  border-radius: 999px;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
</style>