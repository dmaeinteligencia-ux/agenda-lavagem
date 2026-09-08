<template>
  <div class="agenda-filters">
    <div class="filter-group">
      <label class="filter-label">Tipo</label>
      <select class="filter-select">
        <option>Todos</option>
        <option>Caminhão</option>
        <option>Carro</option>
        <option>Ônibus</option>
        <option>Moto</option>
      </select>
    </div>
    <div class="filter-group">
      <label class="filter-label">Status</label>
      <select class="filter-select">
        <option>Todos</option>
        <option>RESERVADA</option>
        <option>EM_LAVAGEM</option>
        <option>CONCLUIDA</option>
        <option>CANCELADA</option>
        <option>EXPIRADA</option>
      </select>
    </div>
    <div class="filter-group">
      <label class="filter-label">Regime</label>
      <select class="filter-select">
        <option>Todos</option>
        <option>NORMAL</option>
        <option>PLANTAO</option>
      </select>
    </div>
  </div>
</template>

<style scoped>
.agenda-filters {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 24px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.filter-label {
  font-size: 12px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.filter-select {
  padding: 8px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  font-family: inherit;
  cursor: pointer;
  min-width: 160px;
}

.filter-select:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}
</style>