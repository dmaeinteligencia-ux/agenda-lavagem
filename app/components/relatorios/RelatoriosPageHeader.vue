<template>
  <header class="relatorios-page-header">
    <div class="relatorios-page-header-text">
      <h1 class="relatorios-page-header-title">Relatórios</h1>
      <p class="relatorios-page-header-subtitle">
        Consulte e analise os registros operacionais do lavador.
      </p>
    </div>
  </header>
</template>

<script setup lang="ts">
</script>

<style scoped>
.relatorios-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.relatorios-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.relatorios-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.relatorios-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

@media (max-width: 600px) {
  .relatorios-page-header-title {
    font-size: 20px;
  }

  .relatorios-page-header-subtitle {
    font-size: 13px;
  }
}
</style>
