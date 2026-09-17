<template>
  <div class="relatorio-filtros">
    <div class="relatorio-filtros-grid">
      <div class="relatorio-filter-group">
        <label class="relatorio-filter-label" for="relatorios-filtro-data-inicial">Data inicial</label>
        <input
          id="relatorios-filtro-data-inicial"
          class="relatorio-filter-input"
          type="date"
          :value="dataInicial"
          @change="$emit('update:dataInicial', ($event.target as HTMLInputElement).value)"
        />
      </div>

      <div class="relatorio-filter-group">
        <label class="relatorio-filter-label" for="relatorios-filtro-data-final">Data final</label>
        <input
          id="relatorios-filtro-data-final"
          class="relatorio-filter-input"
          type="date"
          :value="dataFinal"
          @change="$emit('update:dataFinal', ($event.target as HTMLInputElement).value)"
        />
      </div>

      <div v-if="tipo === 'RESERVAS'" class="relatorio-filter-group">
        <label class="relatorio-filter-label" for="relatorios-filtro-status">Status</label>
        <div class="relatorio-filter-select-wrapper">
          <select
            id="relatorios-filtro-status"
            class="relatorio-filter-select"
            :value="status"
            @change="$emit('update:status', ($event.target as HTMLSelectElement).value)"
          >
            <option value="">Todos os status</option>
            <option v-for="item in statusOpcoes" :key="item.value" :value="item.value">
              {{ item.label }}
            </option>
          </select>
          <ChevronDownIcon class="relatorio-filter-icon" aria-hidden="true" />
        </div>
      </div>

      <div v-if="tipo === 'OCORRENCIAS'" class="relatorio-filter-group">
        <label class="relatorio-filter-label" for="relatorios-filtro-ocorrencia">Tipo de ocorrência</label>
        <div class="relatorio-filter-select-wrapper">
          <select
            id="relatorios-filtro-ocorrencia"
            class="relatorio-filter-select"
            :value="ocorrencia"
            @change="$emit('update:ocorrencia', ($event.target as HTMLSelectElement).value)"
          >
            <option value="">Todas as ocorrências</option>
            <option v-for="item in ocorrenciaOpcoes" :key="item.value" :value="item.value">
              {{ item.label }}
            </option>
          </select>
          <ChevronDownIcon class="relatorio-filter-icon" aria-hidden="true" />
        </div>
      </div>

      <div class="relatorio-filter-group">
        <label class="relatorio-filter-label" for="relatorios-filtro-tipo">Tipo de veículo</label>
        <div class="relatorio-filter-select-wrapper">
          <select
            id="relatorios-filtro-tipo"
            class="relatorio-filter-select"
            :value="tipoId"
            @change="$emit('update:tipoId', ($event.target as HTMLSelectElement).value)"
          >
            <option value="">Todos os tipos</option>
            <option v-for="item in tipos" :key="item.id" :value="item.id">
              {{ item.descricao }}
            </option>
          </select>
          <ChevronDownIcon class="relatorio-filter-icon" aria-hidden="true" />
        </div>
      </div>

      <div class="relatorio-filter-group relatorio-filter-group--busca">
        <label class="relatorio-filter-label" for="relatorios-filtro-busca">
          {{ buscaLabel }}
        </label>
        <div class="relatorio-filter-input-wrapper">
          <MagnifyingGlassIcon class="relatorio-filter-busca-icon" aria-hidden="true" />
          <input
            id="relatorios-filtro-busca"
            class="relatorio-filter-input relatorio-filter-input--busca"
            type="text"
            :value="busca"
            :placeholder="buscaPlaceholder"
            @input="$emit('update:busca', ($event.target as HTMLInputElement).value)"
          />
        </div>
      </div>
    </div>

    <p v-if="periodoInvalido" class="relatorio-filtros-erro" role="alert">
      A data inicial não pode ser posterior à data final.
    </p>

    <div class="relatorio-filtros-acoes">
      <button
        type="button"
        class="relatorio-btn relatorio-btn--primary"
        :disabled="!podeGerar"
        :aria-busy="loading"
        @click="$emit('gerar')"
      >
        <ArrowPathIcon v-if="loading" class="relatorio-btn-icon relatorio-btn-icon--spin" aria-hidden="true" />
        <PlayIcon v-else class="relatorio-btn-icon" aria-hidden="true" />
        {{ loading ? 'Gerando...' : 'Gerar relatório' }}
      </button>
      <button
        type="button"
        class="relatorio-btn relatorio-btn--secondary"
        :disabled="!podeLimpar"
        @click="$emit('limpar')"
      >
        <ArrowPathIcon class="relatorio-btn-icon" aria-hidden="true" />
        Limpar filtros
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import {
  ArrowPathIcon,
  ChevronDownIcon,
  MagnifyingGlassIcon,
  PlayIcon
} from '@heroicons/vue/24/outline'
import { STATUS_OPCOES, type TipoVeiculoAdmin } from '@/utils/reservasAdmin'
import { OCORRENCIA_OPCOES, type TipoRelatorio } from '@/utils/relatorios'

interface Props {
  tipo: TipoRelatorio
  dataInicial: string
  dataFinal: string
  status: string
  tipoId: string
  busca: string
  ocorrencia: string
  tipos: TipoVeiculoAdmin[]
  podeLimpar: boolean
  periodoInvalido: boolean
  loading: boolean
}

const props = defineProps<Props>()

defineEmits<{
  'update:dataInicial': [value: string]
  'update:dataFinal': [value: string]
  'update:status': [value: string]
  'update:tipoId': [value: string]
  'update:busca': [value: string]
  'update:ocorrencia': [value: string]
  gerar: []
  limpar: []
}>()

const statusOpcoes = STATUS_OPCOES
const ocorrenciaOpcoes = OCORRENCIA_OPCOES

const buscaLabel = computed(() =>
  props.tipo === 'POR_VEICULO' ? 'Busca por veículo/placa/modelo' : 'Busca'
)

const buscaPlaceholder = computed(() =>
  props.tipo === 'POR_VEICULO'
    ? 'Veículo, placa ou modelo'
    : 'Veículo, placa, modelo, solicitante ou matrícula'
)

const podeGerar = computed(
  () =>
    !props.loading &&
    props.dataInicial !== '' &&
    props.dataFinal !== '' &&
    !props.periodoInvalido
)
</script>

<style scoped>
.relatorio-filtros {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 20px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.relatorio-filtros-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.relatorio-filter-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.relatorio-filter-group--busca {
  grid-column: span 2;
}

.relatorio-filter-label {
  font-size: 12px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.relatorio-filter-input,
.relatorio-filter-select {
  width: 100%;
  padding: 8px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  font-family: inherit;
  box-sizing: border-box;
}

.relatorio-filter-select {
  cursor: pointer;
  appearance: none;
  padding-right: 36px;
}

.relatorio-filter-input:focus,
.relatorio-filter-select:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}

.relatorio-filter-select-wrapper,
.relatorio-filter-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.relatorio-filter-icon {
  position: absolute;
  right: 10px;
  width: 16px;
  height: 16px;
  color: #6b7280;
  pointer-events: none;
}

.relatorio-filter-input--busca {
  padding-left: 36px;
}

.relatorio-filter-busca-icon {
  position: absolute;
  left: 10px;
  width: 16px;
  height: 16px;
  color: #9ca3af;
  pointer-events: none;
}

.relatorio-filtros-erro {
  margin: 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.relatorio-filtros-acoes {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.relatorio-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  border: 1px solid transparent;
  transition: background-color 0.15s, border-color 0.15s, color 0.15s;
}

.relatorio-btn:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.relatorio-btn--primary {
  background-color: #004790;
  color: #fff;
  border-color: #004790;
}

.relatorio-btn--primary:hover:not(:disabled) {
  background-color: #003570;
  border-color: #003570;
}

.relatorio-btn--secondary {
  background: #fff;
  color: #4b5563;
  border-color: #e5e7eb;
}

.relatorio-btn--secondary:hover:not(:disabled) {
  background: #f9fafb;
  border-color: #d1d5db;
  color: #004790;
}

.relatorio-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.relatorio-btn-icon {
  width: 16px;
  height: 16px;
}

.relatorio-btn-icon--spin {
  animation: relatorio-btn-spin 0.8s linear infinite;
}

@keyframes relatorio-btn-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 1024px) {
  .relatorio-filtros-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 600px) {
  .relatorio-filtros {
    padding: 16px;
  }

  .relatorio-filtros-grid {
    grid-template-columns: 1fr;
  }

  .relatorio-filter-group--busca {
    grid-column: span 1;
  }

  .relatorio-filtros-acoes {
    flex-direction: column;
  }

  .relatorio-btn {
    width: 100%;
  }
}
</style>
