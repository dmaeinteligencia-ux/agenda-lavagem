<template>
  <div class="relatorios-page">
    <div class="relatorios-print-header relatorios-print-only">
      <p class="relatorios-print-org">DMAE</p>
      <p class="relatorios-print-setor">Gestão do Lavador da Frota</p>
      <h1 class="relatorios-print-title">{{ tituloRelatorio }}</h1>
      <p class="relatorios-print-linha">Período: {{ periodoTexto }}</p>
      <p class="relatorios-print-linha">Emitido em: {{ emitidoEmTexto }}</p>
      <p class="relatorios-print-linha">Filtros: {{ filtrosTexto }}</p>
    </div>

    <div class="relatorios-no-print">
      <RelatoriosPageHeader />
      <RelatorioTipoSelector v-model="tipoRelatorio" />
      <RelatorioFiltros
        :tipo="tipoRelatorio"
        v-model:data-inicial="filtros.dataInicial"
        v-model:data-final="filtros.dataFinal"
        v-model:status="filtros.status"
        v-model:tipo-id="filtros.tipoId"
        v-model:busca="filtros.busca"
        v-model:ocorrencia="filtros.ocorrencia"
        :tipos="tipos"
        :pode-limpar="podeLimpar"
        :periodo-invalido="periodoInvalido"
        :loading="loading"
        @gerar="gerarRelatorio"
        @limpar="limparFiltros"
      />
    </div>

    <div v-if="loading" class="relatorios-state relatorios-no-print" aria-busy="true">
      <span class="relatorios-spinner" aria-hidden="true" />
      <span>Gerando relatório...</span>
    </div>

    <div
      v-else-if="error"
      class="relatorios-state relatorios-state--erro relatorios-no-print"
      role="alert"
    >
      <p class="relatorios-state-message">{{ error }}</p>
      <button type="button" class="relatorios-retry" @click="gerarRelatorio">
        Tentar novamente
      </button>
    </div>

    <RelatorioEmptyState
      v-else-if="!gerado"
      class="relatorios-no-print"
      title="Selecione os filtros e gere um relatório."
      description="Escolha o tipo de relatório, ajuste o período e clique em Gerar relatório."
    />

    <RelatorioEmptyState
      v-else-if="total === 0"
      class="relatorios-no-print"
      title="Nenhum resultado encontrado para os filtros selecionados."
      description="Ajuste o período ou os filtros e gere novamente."
    />

    <template v-else>
      <div class="relatorios-resultado-header relatorios-no-print">
        <div class="relatorios-resultado-text">
          <h2 class="relatorios-resultado-titulo">{{ tituloRelatorio }}</h2>
          <p class="relatorios-resultado-periodo">Período: {{ periodoTexto }}</p>
        </div>
        <button type="button" class="relatorios-imprimir-btn" @click="imprimir">
          <PrinterIcon class="relatorios-imprimir-icon" aria-hidden="true" />
          Imprimir
        </button>
      </div>

      <RelatorioResumo :resumo="resumo" />

      <RelatorioTabela
        :tipo="tipoRelatorio"
        :linhas="linhasPagina"
        :veiculos="veiculosPagina"
        :page="pagina"
        :page-size="PAGE_SIZE"
        :total="total"
        @update:page="pagina = $event"
      />

      <RelatorioTabela
        class="relatorios-print-only"
        :tipo="tipoRelatorio"
        :linhas="linhasFiltradas"
        :veiculos="veiculosAgrupados"
        :page="1"
        :page-size="total"
        :total="total"
        imprimir
      />
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted, nextTick } from 'vue'
import { PrinterIcon } from '@heroicons/vue/24/outline'
import RelatoriosPageHeader from '@/components/relatorios/RelatoriosPageHeader.vue'
import RelatorioTipoSelector from '@/components/relatorios/RelatorioTipoSelector.vue'
import RelatorioFiltros from '@/components/relatorios/RelatorioFiltros.vue'
import RelatorioResumo from '@/components/relatorios/RelatorioResumo.vue'
import RelatorioTabela from '@/components/relatorios/RelatorioTabela.vue'
import RelatorioEmptyState from '@/components/relatorios/RelatorioEmptyState.vue'
import { useRelatorios } from '@/composables/useRelatorios'
import { formatarDataHora } from '@/utils/reservasAdmin'
import {
  RELATORIOS_PAGE_SIZE,
  TIPO_RELATORIO_TITULOS,
  agruparPorVeiculo,
  descreverFiltros,
  filtrarLinhas,
  formatarPeriodo,
  periodoInvalido as periodoEstaInvalido,
  relatorioFiltrosIniciais,
  resumoLavagens,
  resumoOcorrencias,
  resumoPorVeiculo,
  resumoReservas,
  type RelatorioFiltros as RelatorioFiltrosState,
  type RelatorioLinha,
  type ResumoRelatorio,
  type TipoRelatorio
} from '@/utils/relatorios'

definePageMeta({
  layout: 'default'
})

const PAGE_SIZE = RELATORIOS_PAGE_SIZE

const { tipos, loading, error, carregarTipos, gerar } = useRelatorios()

const tipoRelatorio = ref<TipoRelatorio>('RESERVAS')
const filtros = reactive<RelatorioFiltrosState>(relatorioFiltrosIniciais())

const linhasBase = ref<RelatorioLinha[]>([])
const gerado = ref(false)
const pagina = ref(1)
const emitidoEm = ref('')

const periodoInvalido = computed(() => periodoEstaInvalido(filtros))

const linhasFiltradas = computed(() =>
  filtrarLinhas(linhasBase.value, tipoRelatorio.value, filtros)
)

const veiculosAgrupados = computed(() =>
  tipoRelatorio.value === 'POR_VEICULO' ? agruparPorVeiculo(linhasFiltradas.value) : []
)

const total = computed(() =>
  tipoRelatorio.value === 'POR_VEICULO'
    ? veiculosAgrupados.value.length
    : linhasFiltradas.value.length
)

const linhasPagina = computed(() => {
  if (tipoRelatorio.value === 'POR_VEICULO') {
    return []
  }

  const inicio = (pagina.value - 1) * PAGE_SIZE
  return linhasFiltradas.value.slice(inicio, inicio + PAGE_SIZE)
})

const veiculosPagina = computed(() => {
  if (tipoRelatorio.value !== 'POR_VEICULO') {
    return []
  }

  const inicio = (pagina.value - 1) * PAGE_SIZE
  return veiculosAgrupados.value.slice(inicio, inicio + PAGE_SIZE)
})

const resumo = computed<ResumoRelatorio>(() => {
  switch (tipoRelatorio.value) {
    case 'LAVAGENS':
      return { tipo: 'LAVAGENS', dados: resumoLavagens(linhasFiltradas.value) }
    case 'OCORRENCIAS':
      return { tipo: 'OCORRENCIAS', dados: resumoOcorrencias(linhasFiltradas.value) }
    case 'POR_VEICULO':
      return { tipo: 'POR_VEICULO', dados: resumoPorVeiculo(veiculosAgrupados.value) }
    default:
      return { tipo: 'RESERVAS', dados: resumoReservas(linhasFiltradas.value) }
  }
})

const tituloRelatorio = computed(() => TIPO_RELATORIO_TITULOS[tipoRelatorio.value])
const periodoTexto = computed(() => formatarPeriodo(filtros.dataInicial, filtros.dataFinal))
const emitidoEmTexto = computed(() =>
  emitidoEm.value ? formatarDataHora(emitidoEm.value) : '—'
)
const filtrosTexto = computed(() =>
  descreverFiltros(tipoRelatorio.value, filtros, tipos.value).join(' · ')
)

const podeLimpar = computed(() => {
  const iniciais = relatorioFiltrosIniciais()

  return (
    filtros.dataInicial !== iniciais.dataInicial ||
    filtros.dataFinal !== iniciais.dataFinal ||
    filtros.status !== '' ||
    filtros.tipoId !== '' ||
    filtros.busca !== '' ||
    filtros.ocorrencia !== ''
  )
})

const gerarRelatorio = async () => {
  if (periodoInvalido.value) {
    return
  }

  pagina.value = 1
  const resultado = await gerar(filtros.dataInicial, filtros.dataFinal)

  linhasBase.value = resultado.linhas
  gerado.value = resultado.success
  emitidoEm.value = resultado.success ? new Date().toISOString() : ''
}

const limparFiltros = () => {
  Object.assign(filtros, relatorioFiltrosIniciais())
  linhasBase.value = []
  gerado.value = false
  pagina.value = 1
  emitidoEm.value = ''
}

const imprimir = async () => {
  emitidoEm.value = new Date().toISOString()
  await nextTick()
  window.print()
}

watch(tipoRelatorio, () => {
  pagina.value = 1
  linhasBase.value = []
  gerado.value = false
  emitidoEm.value = ''
})

watch(filtros, () => {
  pagina.value = 1
})

watch(total, (valor) => {
  const maxPaginas = Math.max(1, Math.ceil(valor / PAGE_SIZE))

  if (pagina.value > maxPaginas) {
    pagina.value = maxPaginas
  }
})

onMounted(carregarTipos)
</script>

<style scoped>
.relatorios-page {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.relatorios-state {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 12px;
  padding: 60px 24px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  color: #6b7280;
  font-size: 14px;
  text-align: center;
}

.relatorios-state--erro {
  color: #4b5563;
}

.relatorios-state-message {
  margin: 0;
}

.relatorios-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: relatorios-spin 0.8s linear infinite;
}

@keyframes relatorios-spin {
  to {
    transform: rotate(360deg);
  }
}

.relatorios-retry {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #004790;
  background: #fff;
  border: 1px solid #004790;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
}

.relatorios-retry:hover {
  background: #e8f0fe;
}

.relatorios-resultado-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.relatorios-resultado-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0;
}

.relatorios-resultado-titulo {
  font-size: 18px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.relatorios-resultado-periodo {
  font-size: 13px;
  color: #6b7280;
  margin: 0;
}

.relatorios-imprimir-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s;
}

.relatorios-imprimir-btn:hover {
  background-color: #003570;
}

.relatorios-imprimir-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.relatorios-imprimir-icon {
  width: 18px;
  height: 18px;
}

.relatorios-print-only {
  display: none;
}

.relatorios-print-header {
  margin-bottom: 16px;
}

.relatorios-print-org {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #004790;
}

.relatorios-print-setor {
  margin: 0 0 8px;
  font-size: 12px;
  color: #374151;
}

.relatorios-print-title {
  margin: 0 0 8px;
  font-size: 16px;
  font-weight: 700;
  color: #111827;
  text-transform: uppercase;
}

.relatorios-print-linha {
  margin: 0;
  font-size: 12px;
  color: #374151;
}

@media (max-width: 1024px) {
  .relatorios-page {
    padding: 20px 16px;
  }
}

@media (max-width: 600px) {
  .relatorios-page {
    padding: 16px 12px;
    gap: 16px;
  }

  .relatorios-imprimir-btn {
    width: 100%;
    justify-content: center;
  }
}
</style>

<style>
@page {
  size: A4 landscape;
  margin: 10mm;
}

@media print {
  .header,
  .sidebar,
  .sidebar-drawer {
    display: none !important;
  }

  .layout {
    background: #fff !important;
    min-height: 0 !important;
  }

  .layout-body {
    display: block !important;
  }

  .content {
    height: auto !important;
    overflow: visible !important;
    padding: 0 !important;
  }

  .relatorios-no-print {
    display: none !important;
  }

  .relatorios-print-only {
    display: block !important;
  }

  .relatorios-page {
    padding: 0 !important;
    max-width: none !important;
    gap: 12px !important;
  }

  .relatorio-tabela {
    min-width: 0 !important;
    width: 100% !important;
  }

  .relatorio-tabela-container {
    overflow: visible !important;
  }

  .relatorio-tabela-header-cell,
  .relatorio-tabela-cell {
    font-size: 10px !important;
    padding: 5px 6px !important;
  }

  .relatorio-tabela-row {
    break-inside: avoid;
    page-break-inside: avoid;
  }

  .agenda-summary-card {
    box-shadow: none !important;
    border: 1px solid #d1d5db !important;
    padding: 10px !important;
  }

  .agenda-summary-card-value {
    font-size: 16px !important;
  }

  .agenda-status-badge {
    font-size: 9px !important;
    padding: 2px 8px !important;
  }
}
</style>
