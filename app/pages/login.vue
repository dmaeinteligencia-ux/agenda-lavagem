<template>
  <div class="login-page">
    <LoginInstitutionalPanel />
    <LoginPanel />
  </div>
</template>

<script setup lang="ts">
import LoginInstitutionalPanel from '@/components/auth/LoginInstitutionalPanel.vue'
import LoginPanel from '@/components/auth/LoginPanel.vue'

definePageMeta({
  layout: false
})
</script>

<style scoped>
.login-page {
  display: grid;
  grid-template-columns: 1fr 1.4fr;
  min-height: 100vh;
  width: 100%;
}

@media (max-width: 1024px) {
  .login-page {
    grid-template-columns: 1fr;
    grid-template-rows: 180px 1fr;
  }
}

@media (max-width: 480px) {
  .login-page {
    grid-template-rows: 120px 1fr;
  }
}
</style>