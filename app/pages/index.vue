<template>
  <div />
</template>

<script setup lang="ts">
definePageMeta({
  middleware: [
    () => navigateTo('/agenda-lavador', { replace: true })
  ]
})
</script>
