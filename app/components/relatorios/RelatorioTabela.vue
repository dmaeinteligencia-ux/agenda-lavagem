<template>
  <div class="relatorio-tabela-wrapper">
    <div class="relatorio-tabela-container">
      <table class="relatorio-tabela">
        <thead>
          <tr class="relatorio-tabela-header">
            <th
              v-for="coluna in colunas"
              :key="coluna"
              class="relatorio-tabela-header-cell"
            >
              {{ coluna }}
            </th>
          </tr>
        </thead>
        <tbody>
          <template v-if="tipo === 'POR_VEICULO'">
            <tr
              v-for="item in veiculos"
              :key="item.veiculoId"
              class="relatorio-tabela-row"
            >
              <td class="relatorio-tabela-cell relatorio-tabela-cell--strong">{{ item.veiculo }}</td>
              <td class="relatorio-tabela-cell">{{ item.placa }}</td>
              <td class="relatorio-tabela-cell">{{ item.tipo }}</td>
              <td class="relatorio-tabela-cell">{{ item.total }}</td>
              <td class="relatorio-tabela-cell">{{ item.concluidas }}</td>
              <td class="relatorio-tabela-cell">{{ item.ocorrencias }}</td>
              <td class="relatorio-tabela-cell">
                {{ item.ultimaLavagem ? formatarDataCurta(item.ultimaLavagem) : '—' }}
              </td>
            </tr>
          </template>

          <template v-else>
            <tr v-for="linha in linhas" :key="linha.id" class="relatorio-tabela-row">
            <td class="relatorio-tabela-cell relatorio-tabela-cell--nowrap">
              {{ formatarDataCurta(linha.data) }}
            </td>
            <td class="relatorio-tabela-cell relatorio-tabela-cell--strong">{{ linha.veiculo }}</td>
            <td class="relatorio-tabela-cell">{{ linha.placa }}</td>

            <template v-if="tipo === 'RESERVAS'">
              <td class="relatorio-tabela-cell">{{ linha.tipo }}</td>
              <td class="relatorio-tabela-cell">{{ linha.solicitante }}</td>
              <td class="relatorio-tabela-cell">{{ linha.matricula }}</td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--nowrap">{{ linha.tempoEstimado }} min</td>
              <td class="relatorio-tabela-cell">
                <AgendaStatusBadge :status="linha.status" />
              </td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--wide">
                {{ linha.observacao || '—' }}
              </td>
            </template>

            <template v-else-if="tipo === 'LAVAGENS'">
              <td class="relatorio-tabela-cell">{{ linha.tipo }}</td>
              <td class="relatorio-tabela-cell">{{ linha.solicitante }}</td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--nowrap">
                {{ formatarHora(linha.inicio) || '—' }}
              </td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--nowrap">
                {{ formatarHora(linha.fim) || '—' }}
              </td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--nowrap">
                {{ formatarDuracao(linha.duracaoRealMinutos) }}
              </td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--nowrap">{{ linha.tempoEstimado }} min</td>
            </template>

            <template v-else>
              <td class="relatorio-tabela-cell">{{ linha.solicitante }}</td>
              <td class="relatorio-tabela-cell">
                <AgendaStatusBadge :status="linha.status" />
              </td>
              <td class="relatorio-tabela-cell">{{ labelMotivo(linha.motivo) || '—' }}</td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--wide">
                {{ linha.observacaoEvento || '—' }}
              </td>
              <td class="relatorio-tabela-cell relatorio-tabela-cell--nowrap">
                {{ linha.registradoEm ? formatarDataHora(linha.registradoEm) : '—' }}
              </td>
            </template>
          </tr>
          </template>
        </tbody>
      </table>
    </div>

    <ReservasPagination
      v-if="!imprimir"
      :page="page"
      :page-size="pageSize"
      :total="total"
      @update:page="$emit('update:page', $event)"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import AgendaStatusBadge from '@/components/agenda/AgendaStatusBadge.vue'
import ReservasPagination from '@/components/reservas/ReservasPagination.vue'
import { formatarHora } from '@/utils/reservas'
import {
  formatarDataCurta,
  formatarDataHora,
  labelMotivo
} from '@/utils/reservasAdmin'
import {
  formatarDuracao,
  type RelatorioLinha,
  type RelatorioVeiculoLinha,
  type TipoRelatorio
} from '@/utils/relatorios'

interface Props {
  tipo: TipoRelatorio
  linhas: RelatorioLinha[]
  veiculos: RelatorioVeiculoLinha[]
  page: number
  pageSize: number
  total: number
  imprimir?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  imprimir: false
})

defineEmits<{
  'update:page': [value: number]
}>()

const COLUNAS: Record<TipoRelatorio, string[]> = {
  RESERVAS: [
    'Data',
    'Veículo',
    'Placa',
    'Tipo',
    'Solicitante',
    'Matrícula',
    'Tempo estimado',
    'Status',
    'Observação'
  ],
  LAVAGENS: [
    'Data',
    'Veículo',
    'Placa',
    'Tipo',
    'Solicitante',
    'Início',
    'Fim',
    'Duração real',
    'Tempo estimado'
  ],
  OCORRENCIAS: [
    'Data',
    'Veículo',
    'Placa',
    'Solicitante',
    'Ocorrência',
    'Motivo',
    'Observação',
    'Registrado em'
  ],
  POR_VEICULO: [
    'Veículo',
    'Placa',
    'Tipo',
    'Total de reservas',
    'Concluídas',
    'Ocorrências',
    'Última lavagem'
  ]
}

const colunas = computed(() => COLUNAS[props.tipo])
</script>

<style scoped>
.relatorio-tabela-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.relatorio-tabela-container {
  overflow-x: auto;
}

.relatorio-tabela {
  width: 100%;
  border-collapse: collapse;
  min-width: 900px;
}

.relatorio-tabela-header {
  background: #f8fafc;
  border-bottom: 1px solid #e5e7eb;
}

.relatorio-tabela-header-cell {
  padding: 12px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.relatorio-tabela-row {
  border-bottom: 1px solid #f1f5f9;
}

.relatorio-tabela-row:last-child {
  border-bottom: none;
}

.relatorio-tabela-cell {
  padding: 12px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
}

.relatorio-tabela-cell--strong {
  font-weight: 600;
  color: #111827;
}

.relatorio-tabela-cell--nowrap {
  white-space: nowrap;
}

.relatorio-tabela-cell--wide {
  min-width: 220px;
}
</style>
