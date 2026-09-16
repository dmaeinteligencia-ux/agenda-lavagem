<template>
  <section class="nova-reserva-card" aria-labelledby="nova-reserva-solicitante-title">
    <header class="nova-reserva-card-header">
      <h2 id="nova-reserva-solicitante-title" class="nova-reserva-card-title">
        <span class="nova-reserva-card-step" aria-hidden="true">1</span>
        Solicitante
      </h2>
      <p class="nova-reserva-card-subtitle">Pesquise o solicitante pela matrícula.</p>
    </header>
    <div class="nova-reserva-card-body nova-reserva-solicitante-card-body">
      <div class="nova-reserva-solicitante-search">
        <div class="nova-reserva-solicitante-search-field">
          <label for="nova-reserva-matricula" class="nova-reserva-solicitante-search-label">
            Matrícula do solicitante
          </label>
          <div class="nova-reserva-solicitante-search-input-wrap">
            <IdentificationIcon class="nova-reserva-solicitante-search-icon" aria-hidden="true" />
            <input
              id="nova-reserva-matricula"
              v-model="matricula"
              class="nova-reserva-solicitante-search-input"
              type="text"
              placeholder="Digite a matrícula"
              autocomplete="off"
              @keyup.enter="buscar"
            />
          </div>
        </div>
        <button type="button" class="nova-reserva-solicitante-search-btn" :disabled="loading" @click="buscar">
          <span v-if="loading" class="nova-reserva-solicitante-spinner" aria-hidden="true" />
          <span>{{ loading ? 'Buscando...' : 'Pesquisar' }}</span>
        </button>
      </div>

      <p v-if="error" class="nova-reserva-solicitante-error" role="alert">{{ error }}</p>

      <div v-if="solicitante" class="nova-reserva-solicitante-info">
        <UserIcon class="nova-reserva-solicitante-info-icon" aria-hidden="true" />
        <div class="nova-reserva-solicitante-info-text">
          <span class="nova-reserva-solicitante-info-label">Solicitante</span>
          <strong class="nova-reserva-solicitante-info-nome">{{ solicitante.nome }}</strong>
          <span class="nova-reserva-solicitante-info-matricula">Matrícula: {{ solicitante.matricula }}</span>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { IdentificationIcon, UserIcon } from '@heroicons/vue/24/outline'
import type { SolicitanteBusca } from '@/composables/useNovaReserva'

interface Props {
  solicitante: SolicitanteBusca | null
  loading: boolean
  error: string | null
}

defineProps<Props>()

const emit = defineEmits<{
  buscar: [matricula: string]
}>()

const matricula = ref('')

const buscar = () => {
  if (!matricula.value.trim()) {
    return
  }
  emit('buscar', matricula.value.trim())
}
</script>

<style scoped>
.nova-reserva-card {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.nova-reserva-card-header {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-bottom: 20px;
}

.nova-reserva-card-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 0;
  font-size: 17px;
  font-weight: 700;
  color: #111827;
}

.nova-reserva-card-step {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 26px;
  height: 26px;
  border-radius: 50%;
  background: #dbeafe;
  color: #004790;
  font-size: 13px;
  font-weight: 700;
  flex-shrink: 0;
}

.nova-reserva-card-subtitle {
  margin: 0;
  font-size: 13px;
  color: #6b7280;
}

.nova-reserva-card-body {
  display: flex;
  flex-direction: column;
}

.nova-reserva-solicitante-card-body {
  gap: 16px;
}

.nova-reserva-solicitante-search {
  display: flex;
  align-items: flex-end;
  gap: 12px;
  flex-wrap: wrap;
}

.nova-reserva-solicitante-search-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  flex: 1;
  min-width: 220px;
}

.nova-reserva-solicitante-search-label {
  font-size: 13px;
  font-weight: 500;
  color: #374151;
}

.nova-reserva-solicitante-search-input-wrap {
  position: relative;
}

.nova-reserva-solicitante-search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.nova-reserva-solicitante-search-input {
  width: 100%;
  padding: 10px 12px 10px 38px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.nova-reserva-solicitante-search-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.nova-reserva-solicitante-search-btn {
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 600;
  color: #004790;
  background: #fff;
  border: 1px solid #004790;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, color 0.2s, box-shadow 0.2s;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.nova-reserva-solicitante-search-btn:hover:not(:disabled) {
  background: #e8f0fe;
}

.nova-reserva-solicitante-search-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.nova-reserva-solicitante-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: solicitante-spin 0.6s linear infinite;
}

@keyframes solicitante-spin {
  to {
    transform: rotate(360deg);
  }
}

.nova-reserva-solicitante-error {
  margin: 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.nova-reserva-solicitante-info {
  display: flex;
  align-items: center;
  gap: 14px;
  background: #f0f9ff;
  border: 1px solid #bfdbfe;
  border-radius: 12px;
  padding: 16px 20px;
}

.nova-reserva-solicitante-info-icon {
  width: 40px;
  height: 40px;
  padding: 8px;
  border-radius: 10px;
  background: #dbeafe;
  color: #004790;
  flex-shrink: 0;
}

.nova-reserva-solicitante-info-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.nova-reserva-solicitante-info-label {
  font-size: 12px;
  color: #6b7280;
}

.nova-reserva-solicitante-info-nome {
  font-size: 16px;
  font-weight: 700;
  color: #1f2937;
}

.nova-reserva-solicitante-info-matricula {
  font-size: 13px;
  color: #6b7280;
}

@media (max-width: 600px) {
  .nova-reserva-card {
    padding: 18px 16px;
  }

  .nova-reserva-solicitante-search-btn {
    width: 100%;
  }
}
</style>
