<template>
  <div class="access-notice" role="note">
    <ShieldCheckIcon class="notice-icon" aria-hidden="true" />
    <span class="notice-text">Acesso restrito a usuários autorizados.</span>
  </div>
</template>

<script setup lang="ts">
import { ShieldCheckIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.access-notice {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px;
  background: #f0f4f8;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.notice-icon {
  width: 16px;
  height: 16px;
  color: #004790;
  flex-shrink: 0;
}

.notice-text {
  font-size: 12px;
  color: #4b5563;
  line-height: 1.4;
}
</style>