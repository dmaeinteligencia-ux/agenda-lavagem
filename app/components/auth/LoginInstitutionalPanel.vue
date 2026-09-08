<template>
  <aside class="institutional-panel">
    <img src="/capalogin.jpg" alt="" aria-hidden="true" class="institutional-image" />
  </aside>
</template>

<style scoped>
.institutional-panel {
  position: relative;
  background: #004790;
  min-height: 100vh;
  overflow: hidden;
  display: flex;
}

.institutional-image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: 0;
}

@media (max-width: 1024px) {
  .institutional-panel {
    min-height: 180px;
    height: 180px;
  }
}

@media (max-width: 480px) {
  .institutional-panel {
    min-height: 120px;
    height: 120px;
  }
}
</style>