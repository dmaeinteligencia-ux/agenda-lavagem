<template>
  <div class="usuarios-page">
    <header class="usuarios-header">
      <h1 class="usuarios-title">Usuários</h1>
      <p class="usuarios-subtitle">Gerencie o acesso e os perfis dos usuários do sistema.</p>
    </header>

    <div v-if="feedback" class="feedback" :class="`feedback--${feedback.type}`" role="status">
      <span>{{ feedback.message }}</span>
      <button type="button" class="feedback-close" aria-label="Fechar" @click="feedback = null">
        <XMarkIcon aria-hidden="true" />
      </button>
    </div>

    <div v-if="checkingAccess" class="usuarios-state">
      <span class="usuarios-spinner" aria-hidden="true" />
      <span>Verificando acesso...</span>
    </div>

    <div v-else-if="loading" class="usuarios-state">
      <span class="usuarios-spinner" aria-hidden="true" />
      <span>Carregando usuários...</span>
    </div>

    <div v-else-if="error" class="usuarios-state usuarios-state--erro" role="alert">
      <p class="usuarios-state-message">{{ error }}</p>
      <button type="button" class="usuarios-retry" @click="carregar">Tentar novamente</button>
    </div>

    <div v-else-if="usuarios.length === 0" class="usuarios-state usuarios-state--erro">
      <p class="usuarios-state-message">Nenhum usuário encontrado.</p>
    </div>

    <UsuarioTable
      v-else
      :usuarios="usuarios"
      :current-user-id="currentUserId"
      :loading="actionLoading"
      @aprovar="(u) => runStatusAction(u, 'ATIVO')"
      @bloquear="(u) => runStatusAction(u, 'BLOQUEADO')"
      @reativar="(u) => runStatusAction(u, 'ATIVO')"
      @alterar-perfil="openPerfilModal"
    />

    <UsuarioPerfilModal
      v-if="perfilModalUsuario"
      :usuario="perfilModalUsuario"
      :loading="actionLoading"
      :error="actionError"
      @close="closePerfilModal"
      @save="handleSavePerfil"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import UsuarioTable from '@/components/usuarios/UsuarioTable.vue'
import UsuarioPerfilModal from '@/components/usuarios/UsuarioPerfilModal.vue'
import { useUsuarios } from '@/composables/useUsuarios'
import type { Usuario } from '@/composables/useUsuarios'

definePageMeta({
  layout: 'default'
})

const { fetchMyProfile } = useAuth()
const user = useSupabaseUser()
const { listarUsuarios, alterarStatus, alterarPerfil } = useUsuarios()

const usuarios = ref<Usuario[]>([])
const loading = ref(true)
const checkingAccess = ref(true)
const error = ref<string | null>(null)
const actionLoading = ref(false)
const actionError = ref<string | null>(null)
const feedback = ref<{ type: 'success' | 'error'; message: string } | null>(null)
const perfilModalUsuario = ref<Usuario | null>(null)

const currentUserId = computed(() => user.value?.sub ?? null)

const carregar = async () => {
  loading.value = true
  error.value = null

  const { data, error: listError } = await listarUsuarios()

  loading.value = false

  if (listError) {
    error.value = listError
    return
  }

  usuarios.value = data ?? []
}

const runStatusAction = async (usuario: Usuario, status: 'ATIVO' | 'BLOQUEADO') => {
  actionLoading.value = true
  actionError.value = null
  feedback.value = null

  const { error: statusError } = await alterarStatus(usuario.id, status)

  actionLoading.value = false

  if (statusError) {
    feedback.value = { type: 'error', message: statusError }
    return
  }

  feedback.value = { type: 'success', message: 'Status atualizado com sucesso.' }
  await carregar()
}

const openPerfilModal = (usuario: Usuario) => {
  actionError.value = null
  perfilModalUsuario.value = usuario
}

const closePerfilModal = () => {
  perfilModalUsuario.value = null
  actionError.value = null
}

const handleSavePerfil = async (perfil: 'ADMIN' | 'GESTAO_FROTA' | 'LAVADOR') => {
  if (!perfilModalUsuario.value) {
    return
  }

  actionLoading.value = true
  actionError.value = null

  const { error: perfilError } = await alterarPerfil(perfilModalUsuario.value.id, perfil)

  actionLoading.value = false

  if (perfilError) {
    actionError.value = perfilError
    return
  }

  const nome = perfilModalUsuario.value.nome || perfilModalUsuario.value.email
  perfilModalUsuario.value = null
  feedback.value = { type: 'success', message: `Perfil de ${nome} alterado com sucesso.` }
  await carregar()
}

onMounted(async () => {
  const { profile } = await fetchMyProfile()
  checkingAccess.value = false

  if (profile?.perfil === 'ADMIN' && profile.status_acesso === 'ATIVO') {
    await carregar()
    return
  }

  await navigateTo('/')
})
</script>

<style scoped>
.usuarios-page {
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.usuarios-header {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.usuarios-title {
  margin: 0;
  font-size: 24px;
  font-weight: 700;
  color: #111827;
}

.usuarios-subtitle {
  margin: 0;
  font-size: 14px;
  color: #6b7280;
}

.feedback {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 14px;
}

.feedback--success {
  background: #dcfce7;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.feedback--error {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
}

.feedback-close {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border: none;
  background: transparent;
  cursor: pointer;
  color: inherit;
  border-radius: 6px;
  flex-shrink: 0;
}

.feedback-close:hover {
  background: rgba(0, 0, 0, 0.06);
}

.feedback-close svg {
  width: 16px;
  height: 16px;
}

.usuarios-state {
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

.usuarios-state--erro {
  color: #4b5563;
}

.usuarios-state-message {
  margin: 0;
}

.usuarios-spinner {
  width: 24px;
  height: 24px;
  border: 3px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: usuarios-spin 0.8s linear infinite;
}

@keyframes usuarios-spin {
  to {
    transform: rotate(360deg);
  }
}

.usuarios-retry {
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

.usuarios-retry:hover {
  background: #e8f0fe;
}

@media (max-width: 768px) {
  .usuarios-page {
    padding: 20px 16px;
  }
}
</style>
