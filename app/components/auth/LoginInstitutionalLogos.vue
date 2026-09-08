<template>
  <div class="institutional-logos">
    <img src="/logopreta.png" alt="DMAE — Prefeitura de Uberlândia" class="logo" />
  </div>
</template>

<style scoped>
.institutional-logos {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 0 12px 0;
}

.logo {
  max-width: 520px;
  width: 100%;
  height: auto;
  object-fit: contain;
}

@media (max-width: 1024px) {
  .institutional-logos {
    padding: 0;
  }

  .logo {
    max-width: 280px;
  }
}

@media (max-width: 480px) {
  .logo {
    max-width: 220px;
  }
}
</style>