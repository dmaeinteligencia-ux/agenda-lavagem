<template>
  <div class="sidebar-drawer">
    <Transition name="fade">
      <div
        v-if="isOpen"
        class="sidebar-overlay"
        @click="close"
        aria-hidden="true"
      />
    </Transition>
    <Transition name="slide">
      <aside v-if="isOpen" class="sidebar sidebar--drawer" role="navigation" aria-label="Menu principal">
        <nav class="sidebar-nav">
          <template v-for="entry in sidebarEntries" :key="entry.type + entry.label">
            <span v-if="entry.type === 'section'" class="sidebar-section-label">{{ entry.label }}</span>
            <NuxtLink
              v-else
              :to="entry.route"
              class="sidebar-btn"
              @click.prevent="close"
            >
              <component :is="entry.icon" class="sidebar-icon" aria-hidden="true" />
              <span class="sidebar-label">{{ entry.label }}</span>
            </NuxtLink>
          </template>
        </nav>
        <div class="sidebar-footer">
          <p v-if="logoutError" class="sidebar-logout-error" role="alert">{{ logoutError }}</p>
          <button
            type="button"
            class="sidebar-logout"
            :disabled="loggingOut"
            @click="handleLogout"
          >
            <span v-if="loggingOut" class="sidebar-logout-spinner" aria-hidden="true" />
            <ArrowRightOnRectangleIcon v-else class="sidebar-icon" aria-hidden="true" />
            <span class="sidebar-label">{{ loggingOut ? 'Saindo...' : 'Sair' }}</span>
          </button>
        </div>
      </aside>
    </Transition>
    <aside class="sidebar sidebar--desktop" role="navigation" aria-label="Menu principal">
      <nav class="sidebar-nav">
        <template v-for="entry in sidebarEntries" :key="entry.type + entry.label">
          <span v-if="entry.type === 'section'" class="sidebar-section-label">{{ entry.label }}</span>
          <NuxtLink
            v-else
            :to="entry.route"
            class="sidebar-btn"
            @click.prevent="close"
          >
            <component :is="entry.icon" class="sidebar-icon" aria-hidden="true" />
            <span class="sidebar-label">{{ entry.label }}</span>
          </NuxtLink>
        </template>
      </nav>
      <div class="sidebar-footer">
        <p v-if="logoutError" class="sidebar-logout-error" role="alert">{{ logoutError }}</p>
        <button
          type="button"
          class="sidebar-logout"
          :disabled="loggingOut"
          @click="handleLogout"
        >
          <span v-if="loggingOut" class="sidebar-logout-spinner" aria-hidden="true" />
          <ArrowRightOnRectangleIcon v-else class="sidebar-icon" aria-hidden="true" />
          <span class="sidebar-label">{{ loggingOut ? 'Saindo...' : 'Sair' }}</span>
        </button>
      </div>
    </aside>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import type { Component } from 'vue'
import {
  HomeIcon,
  CalendarDaysIcon,
  DocumentTextIcon,
  TruckIcon,
  ChartBarIcon,
  UserGroupIcon,
  CalendarIcon,
  UsersIcon,
  ArrowRightOnRectangleIcon
} from '@heroicons/vue/24/outline'

const { isOpen, close } = useSidebar()
const { fetchMyProfile, signOut } = useAuth()
const user = useSupabaseUser()

const isAdmin = ref(false)
const loggingOut = ref(false)
const logoutError = ref<string | null>(null)

interface SidebarLink {
  label: string
  icon: Component
  route: string
}

type SidebarEntry =
  | ({ type: 'link' } & SidebarLink)
  | { type: 'section'; label: string }

const mainNavItems: SidebarLink[] = [
  { label: 'Dashboard', icon: HomeIcon, route: '/' },
  { label: 'Agenda do Lavador', icon: CalendarDaysIcon, route: '/agenda-lavador' },
  { label: 'Reservas', icon: DocumentTextIcon, route: '/reservas' },
  { label: 'Veículos', icon: TruckIcon, route: '/veiculos' },
  { label: 'Solicitantes', icon: UserGroupIcon, route: '/solicitantes' },
  { label: 'Relatórios', icon: ChartBarIcon, route: '/relatorios' }
]

const configNavItems: SidebarLink[] = [
  { label: 'Tipos de Veículo', icon: TruckIcon, route: '/tipos-veiculo' },
  { label: 'Jornada do Lavador', icon: CalendarDaysIcon, route: '/jornada-lavador' },
  { label: 'Calendário Operacional', icon: CalendarIcon, route: '/calendario-operacional' }
]

const sidebarEntries = computed<SidebarEntry[]>(() => {
  const entries: SidebarEntry[] = [
    ...mainNavItems.map((item) => ({ type: 'link' as const, ...item })),
    { type: 'section', label: 'Configurações' },
    ...configNavItems.map((item) => ({ type: 'link' as const, ...item }))
  ]

  if (isAdmin.value) {
    entries.push({ type: 'link', label: 'Usuários', icon: UsersIcon, route: '/usuarios' })
  }

  return entries
})

const carregarPerfil = async () => {
  if (!user.value) {
    isAdmin.value = false
    return
  }

  const { profile } = await fetchMyProfile()
  isAdmin.value = profile?.perfil === 'ADMIN' && profile?.status_acesso === 'ATIVO'
}

const handleLogout = async () => {
  if (loggingOut.value) {
    return
  }

  loggingOut.value = true
  logoutError.value = null

  const result = await signOut()
  loggingOut.value = false

  if (!result.success) {
    logoutError.value = result.message || 'Não foi possível sair.'
    return
  }

  await navigateTo('/login')
}

onMounted(carregarPerfil)
watch(user, carregarPerfil)
</script>

<style scoped>
.sidebar-drawer {
  display: contents;
}

.sidebar {
  background-color: #f0f4f8;
  display: flex;
  flex-direction: column;
  padding: 16px 0;
  border-right: 1px solid #d1d5db;
  flex-shrink: 0;
}

.sidebar--desktop {
  width: 240px;
  min-height: calc(100vh - 64px);
}

.sidebar--drawer {
  display: none;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 0 12px;
  flex: 1;
  overflow-y: auto;
}

.sidebar-section-label {
  margin: 16px 16px 4px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #9ca3af;
}

.sidebar-btn {
  display: flex;
  align-items: center;
  gap: 12px;
  background: transparent;
  border: none;
  color: #374151;
  text-align: left;
  padding: 12px 16px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  transition: background 0.2s, color 0.2s;
  width: 100%;
  text-decoration: none;
}

.sidebar-btn:hover {
  background: #dbeafe;
  color: #004790;
}

.sidebar-btn:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.sidebar-btn.router-link-exact-active {
  background: #dbeafe;
  color: #004790;
}

.sidebar-btn.router-link-exact-active .sidebar-icon {
  color: #004790;
}

.sidebar-icon {
  flex-shrink: 0;
  width: 20px;
  height: 20px;
  color: #6b7280;
  transition: color 0.2s;
}

.sidebar-btn:hover .sidebar-icon,
.sidebar-btn:focus-visible .sidebar-icon {
  color: #004790;
}

.sidebar-footer {
  padding: 12px;
  border-top: 1px solid #d1d5db;
  flex-shrink: 0;
}

.sidebar-logout-error {
  margin: 0 4px 8px;
  font-size: 12px;
  color: #991b1b;
}

.sidebar-logout {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  background: transparent;
  border: none;
  color: #374151;
  text-align: left;
  padding: 12px 16px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  transition: background 0.2s, color 0.2s;
  font-family: inherit;
}

.sidebar-logout:hover:not(:disabled) {
  background: #fee2e2;
  color: #991b1b;
}

.sidebar-logout:hover:not(:disabled) .sidebar-icon {
  color: #991b1b;
}

.sidebar-logout:focus-visible {
  outline: 2px solid #004790;
  outline-offset: -2px;
}

.sidebar-logout:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.sidebar-logout-spinner {
  flex-shrink: 0;
  width: 20px;
  height: 20px;
  border: 2px solid #dbeafe;
  border-top-color: #004790;
  border-radius: 50%;
  animation: sidebar-logout-spin 0.7s linear infinite;
}

@keyframes sidebar-logout-spin {
  to {
    transform: rotate(360deg);
  }
}

.sidebar-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 40;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-enter-active,
.slide-leave-active {
  transition: transform 0.25s ease;
}

.slide-enter-from,
.slide-leave-to {
  transform: translateX(-100%);
}

@media (max-width: 768px) {
  .sidebar--desktop {
    display: none;
  }

  .sidebar--drawer {
    display: flex;
    position: fixed;
    top: 64px;
    left: 0;
    width: 280px;
    height: calc(100vh - 64px);
    min-height: auto;
    z-index: 45;
    border-right: 1px solid #d1d5db;
    box-shadow: 2px 0 12px rgba(0, 0, 0, 0.1);
  }
}
</style>
