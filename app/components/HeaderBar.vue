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
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { Bars3Icon, XMarkIcon } from '@heroicons/vue/24/outline'

const { isOpen, toggle } = useSidebar()
const { fetchMyProfile } = useAuth()
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
  gap: 24px;
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
}

@media (max-width: 480px) {
  .logo {
    height: 32px;
  }
}
</style>
