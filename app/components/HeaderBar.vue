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
        <span class="user-name">Nome do Usuário</span>
        <span class="user-role">ADMIN</span>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { Bars3Icon, XMarkIcon } from '@heroicons/vue/24/outline'

const { isOpen, toggle } = useSidebar()
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