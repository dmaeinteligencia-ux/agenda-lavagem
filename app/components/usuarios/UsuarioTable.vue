<template>
  <div class="usuario-table-wrapper">
    <table class="usuario-table">
      <thead>
        <tr>
          <th class="usuario-th">Nome</th>
          <th class="usuario-th">E-mail</th>
          <th class="usuario-th">Perfil</th>
          <th class="usuario-th">Status</th>
          <th class="usuario-th">Cadastro</th>
          <th class="usuario-th usuario-th--acoes">Ações</th>
        </tr>
      </thead>
      <tbody>
        <UsuarioTableRow
          v-for="usuario in usuarios"
          :key="usuario.id"
          :usuario="usuario"
          :is-current-user="usuario.id === currentUserId"
          :loading="loading"
          @aprovar="$emit('aprovar', usuario)"
          @bloquear="$emit('bloquear', usuario)"
          @reativar="$emit('reativar', usuario)"
          @alterar-perfil="$emit('alterar-perfil', usuario)"
        />
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
import UsuarioTableRow from './UsuarioTableRow.vue'
import type { Usuario } from '@/composables/useUsuarios'

interface Props {
  usuarios: Usuario[]
  currentUserId?: string | null
  loading?: boolean
}

withDefaults(defineProps<Props>(), {
  currentUserId: null,
  loading: false
})

defineEmits<{
  aprovar: [usuario: Usuario]
  bloquear: [usuario: Usuario]
  reativar: [usuario: Usuario]
  'alterar-perfil': [usuario: Usuario]
}>()
</script>

<style scoped>
.usuario-table-wrapper {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  overflow-x: auto;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.usuario-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 720px;
}

.usuario-th {
  padding: 14px 16px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #6b7280;
  text-align: left;
  border-bottom: 1px solid #e5e7eb;
  background: #f9fafb;
}

.usuario-th--acoes {
  text-align: right;
}
</style>
