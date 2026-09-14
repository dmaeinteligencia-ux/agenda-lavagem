<template>
  <tr class="usuario-row">
    <td class="usuario-cell">
      <div class="usuario-nome">
        <span>{{ usuario.nome || '—' }}</span>
        <span v-if="isCurrentUser" class="usuario-voce">Você</span>
      </div>
    </td>
    <td class="usuario-cell">{{ usuario.email }}</td>
    <td class="usuario-cell">
      <UsuarioPerfilBadge :perfil="usuario.perfil" />
    </td>
    <td class="usuario-cell">
      <UsuarioStatusBadge :status="usuario.status_acesso" />
    </td>
    <td class="usuario-cell">{{ formatarData(usuario.created_at) }}</td>
    <td class="usuario-cell usuario-cell--acoes">
      <div class="usuario-acoes">
        <button
          v-if="usuario.status_acesso === 'PENDENTE'"
          type="button"
          class="acao-btn acao-btn--aprovar"
          :disabled="loading"
          @click="$emit('aprovar')"
        >
          Aprovar
        </button>
        <button
          v-if="usuario.status_acesso === 'BLOQUEADO'"
          type="button"
          class="acao-btn acao-btn--aprovar"
          :disabled="loading"
          @click="$emit('reativar')"
        >
          Reativar
        </button>
        <button
          v-if="usuario.status_acesso !== 'BLOQUEADO'"
          type="button"
          class="acao-btn acao-btn--bloquear"
          :disabled="loading"
          @click="$emit('bloquear')"
        >
          Bloquear
        </button>
        <button
          type="button"
          class="acao-btn acao-btn--perfil"
          :disabled="loading"
          @click="$emit('alterar-perfil')"
        >
          Alterar perfil
        </button>
      </div>
    </td>
  </tr>
</template>

<script setup lang="ts">
import UsuarioPerfilBadge from './UsuarioPerfilBadge.vue'
import UsuarioStatusBadge from './UsuarioStatusBadge.vue'
import type { Usuario } from '@/composables/useUsuarios'

interface Props {
  usuario: Usuario
  isCurrentUser?: boolean
  loading?: boolean
}

withDefaults(defineProps<Props>(), {
  isCurrentUser: false,
  loading: false
})

defineEmits<{
  aprovar: []
  bloquear: []
  reativar: []
  'alterar-perfil': []
}>()

const formatarData = (iso: string): string => {
  if (!iso) {
    return '—'
  }
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) {
    return '—'
  }
  const dia = String(d.getDate()).padStart(2, '0')
  const mes = String(d.getMonth() + 1).padStart(2, '0')
  return `${dia}/${mes}/${d.getFullYear()}`
}
</script>

<style scoped>
.usuario-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background-color 0.15s;
}

.usuario-row:hover {
  background-color: #f8fafc;
}

.usuario-row:last-child {
  border-bottom: none;
}

.usuario-cell {
  padding: 14px 16px;
  font-size: 14px;
  color: #374151;
  vertical-align: middle;
}

.usuario-nome {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #111827;
}

.usuario-voce {
  font-size: 11px;
  font-weight: 600;
  color: #004790;
  background: #dbeafe;
  padding: 2px 8px;
  border-radius: 999px;
}

.usuario-cell--acoes {
  text-align: right;
}

.usuario-acoes {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 6px;
  flex-wrap: wrap;
}

.acao-btn {
  padding: 6px 12px;
  font-size: 13px;
  font-weight: 600;
  border-radius: 6px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.15s, color 0.15s;
  border: 1px solid transparent;
}

.acao-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.acao-btn--aprovar {
  background: #dcfce7;
  color: #166534;
}

.acao-btn--aprovar:hover:not(:disabled) {
  background: #bbf7d0;
}

.acao-btn--bloquear {
  background: #fee2e2;
  color: #991b1b;
}

.acao-btn--bloquear:hover:not(:disabled) {
  background: #fecaca;
}

.acao-btn--perfil {
  background: #eff6ff;
  color: #1d4ed8;
}

.acao-btn--perfil:hover:not(:disabled) {
  background: #dbeafe;
}

@media (max-width: 768px) {
  .usuario-cell {
    display: block;
    padding: 6px 0;
    white-space: normal;
  }

  .usuario-cell--acoes {
    text-align: left;
  }

  .usuario-acoes {
    justify-content: flex-start;
  }
}
</style>
