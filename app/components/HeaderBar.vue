<template>
  <header class="header">
    <div class="header-left">
      <button
        class="hamburger-btn"
        :aria-label="isOpen ? 'Fechar menu' : 'Abrir menu'"
        @click="toggle"
      >
        <Bars3Icon v-if="!isOpen" aria-hidden="true" />
        <XMarkIcon v-else aria-hidden="true" />
      </button>
      <img src="/logobranca.png" alt="Logo" class="logo" />
    </div>
    <div class="header-right">
      <div class="user-info">
        <template v-if="carregando">
          <span class="user-name user-name--muted">Carregando...</span>
        </template>
        <template v-else-if="user">
          <span class="user-name">{{ nomeExibido }}</span>
          <span class="user-role">{{ perfilLabel }}</span>
        </template>
      </div>

      <span v-if="user" class="header-divider" aria-hidden="true" />

      <p v-if="logoutError" class="header-logout-error" role="alert">{{ logoutError }}</p>

      <button
        v-if="user"
        type="button"
        class="header-logout"
        title="Sair"
        aria-label="Sair da conta"
        :aria-busy="loggingOut"
        :disabled="loggingOut"
        @click="handleLogout"
      >
        <span v-if="loggingOut" class="header-logout-spinner" aria-hidden="true" />
        <ArrowRightOnRectangleIcon v-else class="header-logout-icon" aria-hidden="true" />
        <span class="header-logout-label">{{ loggingOut ? 'Saindo...' : 'Sair' }}</span>
      </button>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { Bars3Icon, XMarkIcon, ArrowRightOnRectangleIcon } from '@heroicons/vue/24/outline'

const { isOpen, toggle } = useSidebar()
const { fetchMyProfile } = useAuth()
const { loggingOut, logoutError, handleLogout } = useLogout()
const user = useSupabaseUser()

const nome = ref<string | null>(null)
const perfil = ref<string | null>(null)
const carregando = ref(false)

const perfilLabel = computed(() => {
  switch (perfil.value) {
    case 'ADMIN':
      return 'Administrador'
    case 'GESTAO_FROTA':
      return 'Gestão de Frota'
    case 'LAVADOR':
      return 'Lavador'
    default:
      return ''
  }
})

const nomeExibido = computed(() => {
  if (nome.value) {
    return nome.value
  }
  if (user.value?.email) {
    return user.value.email
  }
  return 'Usuário'
})

const carregarPerfil = async () => {
  if (!user.value) {
    carregando.value = false
    nome.value = null
    perfil.value = null
    return
  }

  carregando.value = true

  const { profile } = await fetchMyProfile()

  carregando.value = false

  if (profile) {
    nome.value = profile.nome
    perfil.value = profile.perfil
  } else {
    nome.value = null
    perfil.value = null
  }
}

onMounted(carregarPerfil)
watch(user, carregarPerfil)
</script>

<style scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #004790;
  color: #fff;
  padding: 0 24px;
  height: 64px;
  flex-shrink: 0;
  position: sticky;
  top: 0;
  z-index: 50;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.logo {
  height: 40px;
  width: auto;
}

.hamburger-btn {
  display: none;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  background: transparent;
  border: none;
  color: #fff;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s;
}

.hamburger-btn:hover {
  background: rgba(255, 255, 255, 0.15);
}

.hamburger-btn svg {
  width: 24px;
  height: 24px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 0;
}

.user-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  line-height: 1.3;
}

.user-name {
  font-size: 14px;
  font-weight: 500;
}

.user-name--muted {
  opacity: 0.8;
}

.user-role {
  font-size: 12px;
  opacity: 0.8;
}

.header-divider {
  width: 1px;
  height: 22px;
  background: rgba(255, 255, 255, 0.3);
  flex-shrink: 0;
}

.header-logout-error {
  margin: 0;
  max-width: 200px;
  font-size: 12px;
  color: #fecaca;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.header-logout {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: transparent;
  border: none;
  border-radius: 8px;
  color: #fff;
  font-size: 14px;
  font-weight: 500;
  font-family: inherit;
  cursor: pointer;
  white-space: nowrap;
  transition: background-color 0.2s, color 0.2s;
}

.header-logout:hover:not(:disabled) {
  background: rgba(254, 226, 226, 0.16);
  color: #fecaca;
}

.header-logout:active:not(:disabled) {
  background: rgba(254, 226, 226, 0.28);
}

.header-logout:focus-visible {
  outline: 2px solid #fff;
  outline-offset: 2px;
}

.header-logout:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.header-logout-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

.header-logout-label {
  line-height: 1;
}

.header-logout-spinner {
  flex-shrink: 0;
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: header-logout-spin 0.7s linear infinite;
}

@keyframes header-logout-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 768px) {
  .header {
    padding: 0 16px;
  }

  .hamburger-btn {
    display: inline-flex;
  }

  .user-info {
    display: none;
  }

  .header-divider {
    display: none;
  }
}

@media (max-width: 480px) {
  .logo {
    height: 32px;
  }

  .header-logout-label {
    display: none;
  }
}
</style>
