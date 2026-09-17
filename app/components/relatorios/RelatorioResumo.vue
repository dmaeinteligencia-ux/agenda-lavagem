<template>
  <div class="relatorio-resumo">
    <template v-if="resumo.tipo === 'RESERVAS'">
      <AgendaSummaryCard
        title="Total"
        :value="String(resumo.dados.total)"
        description="Reservas no período"
        :icon="ClipboardDocumentListIcon"
        variant="blue"
      />
      <AgendaSummaryCard
        title="Reservadas"
        :value="String(resumo.dados.reservadas)"
        description="Aguardando atendimento"
        :icon="CalendarDaysIcon"
        variant="amber"
      />
      <AgendaSummaryCard
        title="Concluídas"
        :value="String(resumo.dados.concluidas)"
        description="Lavagens finalizadas"
        :icon="CheckCircleIcon"
        variant="green"
      />
      <AgendaSummaryCard
        title="Ocorrências"
        :value="String(resumo.dados.ocorrencias)"
        description="Não atendidas ou não concluídas"
        :icon="ExclamationTriangleIcon"
        variant="red"
      />
    </template>

    <template v-else-if="resumo.tipo === 'LAVAGENS'">
      <AgendaSummaryCard
        title="Lavagens realizadas"
        :value="String(resumo.dados.total)"
        description="Concluídas no período"
        :icon="CheckCircleIcon"
        variant="green"
      />
      <AgendaSummaryCard
        title="Tempo estimado total"
        :value="formatarDuracao(resumo.dados.tempoEstimadoTotal)"
        description="Soma do tempo previsto"
        :icon="ClockIcon"
        variant="blue"
        compact-value
      />
      <AgendaSummaryCard
        title="Tempo real total"
        :value="formatarDuracao(resumo.dados.tempoRealTotal)"
        :description="`${resumo.dados.comDuracao} de ${resumo.dados.total} com duração registrada`"
        :icon="BoltIcon"
        variant="amber"
        compact-value
      />
    </template>

    <template v-else-if="resumo.tipo === 'OCORRENCIAS'">
      <AgendaSummaryCard
        title="Total"
        :value="String(resumo.dados.total)"
        description="Ocorrências no período"
        :icon="ClipboardDocumentListIcon"
        variant="blue"
      />
      <AgendaSummaryCard
        title="Não compareceu"
        :value="String(resumo.dados.naoCompareceu)"
        description="Veículo não compareceu"
        :icon="ExclamationTriangleIcon"
        variant="amber"
      />
      <AgendaSummaryCard
        title="Não atendida"
        :value="String(resumo.dados.naoAtendida)"
        description="Lavagem não iniciada"
        :icon="XCircleIcon"
        variant="red"
      />
      <AgendaSummaryCard
        title="Não concluída"
        :value="String(resumo.dados.naoConcluida)"
        description="Lavagem interrompida"
        :icon="ExclamationTriangleIcon"
        variant="red"
      />
    </template>

    <template v-else>
      <AgendaSummaryCard
        title="Veículos no período"
        :value="String(resumo.dados.veiculos)"
        description="Veículos com reservas"
        :icon="TruckIcon"
        variant="blue"
      />
      <AgendaSummaryCard
        title="Total de reservas"
        :value="String(resumo.dados.totalReservas)"
        description="Reservas no período"
        :icon="ClipboardDocumentListIcon"
        variant="amber"
      />
      <AgendaSummaryCard
        title="Total concluídas"
        :value="String(resumo.dados.totalConcluidas)"
        description="Lavagens finalizadas"
        :icon="CheckCircleIcon"
        variant="green"
      />
      <AgendaSummaryCard
        title="Total de ocorrências"
        :value="String(resumo.dados.totalOcorrencias)"
        description="Não atendidas ou não concluídas"
        :icon="ExclamationTriangleIcon"
        variant="red"
      />
    </template>
  </div>
</template>

<script setup lang="ts">
import AgendaSummaryCard from '@/components/agenda/AgendaSummaryCard.vue'
import {
  BoltIcon,
  CalendarDaysIcon,
  CheckCircleIcon,
  ClipboardDocumentListIcon,
  ClockIcon,
  ExclamationTriangleIcon,
  TruckIcon,
  XCircleIcon
} from '@heroicons/vue/24/outline'
import { formatarDuracao, type ResumoRelatorio } from '@/utils/relatorios'

interface Props {
  resumo: ResumoRelatorio
}

defineProps<Props>()
</script>

<style scoped>
.relatorio-resumo {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1024px) {
  .relatorio-resumo {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 480px) {
  .relatorio-resumo {
    grid-template-columns: 1fr;
  }
}
</style>
