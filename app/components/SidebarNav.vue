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
          <NuxtLink
            v-for="item in navItems"
            :key="item.label"
            :to="item.route"
            class="sidebar-btn"
            @click.prevent="close"
          >
            <component :is="item.icon" class="sidebar-icon" aria-hidden="true" />
            <span class="sidebar-label">{{ item.label }}</span>
          </NuxtLink>
        </nav>
      </aside>
    </Transition>
    <aside class="sidebar sidebar--desktop" role="navigation" aria-label="Menu principal">
      <nav class="sidebar-nav">
        <NuxtLink
          v-for="item in navItems"
          :key="item.label"
          :to="item.route"
          class="sidebar-btn"
          @click.prevent="close"
        >
          <component :is="item.icon" class="sidebar-icon" aria-hidden="true" />
          <span class="sidebar-label">{{ item.label }}</span>
        </NuxtLink>
      </nav>
    </aside>
  </div>
</template>

<script setup lang="ts">
import {
  HomeIcon,
  CalendarDaysIcon,
  DocumentTextIcon,
  TruckIcon,
  ChartBarIcon,
  Cog6ToothIcon
} from '@heroicons/vue/24/outline'

const { isOpen, close } = useSidebar()

const navItems = [
  { label: 'Dashboard', icon: HomeIcon, route: '/' },
  { label: 'Agenda do Lavador', icon: CalendarDaysIcon, route: '/agenda-lavador' },
  { label: 'Reservas', icon: DocumentTextIcon, route: '/reservas' },
  { label: 'Veículos', icon: TruckIcon, route: '/veiculos' },
  { label: 'Tipos de Veículo', icon: TruckIcon, route: '/tipos-veiculo' },
  { label: 'Jornada do Lavador', icon: CalendarDaysIcon, route: '/jornada-lavador' },
  { label: 'Relatórios', icon: ChartBarIcon, route: '/relatorios' },
  { label: 'Configurações', icon: Cog6ToothIcon, route: '/configuracoes' }
]
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
