<template>
  <span class="perfil-badge" :class="`perfil-badge--${perfilClass}`">{{ label }}</span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  perfil: 'ADMIN' | 'GESTAO_FROTA' | 'LAVADOR'
}

const props = defineProps<Props>()

const labels: Record<string, string> = {
  ADMIN: 'Administrador',
  GESTAO_FROTA: 'Gestão de Frota',
  LAVADOR: 'Lavador'
}

const label = computed(() => labels[props.perfil] ?? props.perfil)

const perfilClass = computed(() => {
  switch (props.perfil) {
    case 'ADMIN':
      return 'admin'
    case 'GESTAO_FROTA':
      return 'gestao'
    default:
      return 'lavador'
  }
})
</script>

<style scoped>
.perfil-badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
}

.perfil-badge--admin {
  background: #dbeafe;
  color: #1d4ed8;
}

.perfil-badge--gestao {
  background: #ede9fe;
  color: #6d28d9;
}

.perfil-badge--lavador {
  background: #e0f2fe;
  color: #0369a1;
}
</style>
