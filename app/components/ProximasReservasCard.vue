<template>
  <div class="proximas-reservas-card">
    <div class="proximas-header">
      <h3 class="proximas-title">Próximas Reservas</h3>
      <button class="proximas-btn">Ver todas</button>
    </div>
    <div class="proximas-list">
      <ProximaReservaItem
        v-for="r in reservas"
        :key="r.veiculo + r.data"
        :veiculo="r.veiculo"
        :placa="r.placa"
        :tipo="r.tipo"
        :regime="r.regime"
        :horario="r.horario"
        :status="r.status"
        :data="r.data"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import ProximaReservaItem from './ProximaReservaItem.vue'

const reservas = [
  { data: '2026-08-27', veiculo: 'A11-1234', placa: 'ABC-1A23', tipo: 'Caminhão', regime: 'NORMAL', horario: '08:00', status: 'RESERVADA' },
  { data: '2026-08-28', veiculo: 'A11-5678', placa: 'XYZ-9B12', tipo: 'Carro', regime: 'PLANTÃO', horario: '14:30', status: 'RESERVADA' }
]
</script>

<style scoped>
.proximas-reservas-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  height: 100%;
  display: flex;
  flex-direction: column;
}

.proximas-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  flex-shrink: 0;
}

.proximas-title {
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.proximas-btn {
  font-size: 13px;
  color: #004790;
  font-weight: 600;
  background: none;
  border: none;
  cursor: pointer;
}

.proximas-list {
  display: flex;
  flex-direction: column;
  flex: 1;
  overflow-y: auto;
  max-height: 380px;
}
</style>