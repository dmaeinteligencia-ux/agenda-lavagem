<template>
  <header class="jornada-lavador-page-header">
    <div class="jornada-lavador-page-header-text">
      <h1 class="jornada-lavador-page-header-title">Jornada do Lavador</h1>
      <p class="jornada-lavador-page-header-subtitle">
        Configure as horas disponíveis da jornada por regime.
      </p>
    </div>
  </header>
</template>

<script setup lang="ts">
</script>

<style scoped>
.jornada-lavador-page-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.jornada-lavador-page-header-text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.jornada-lavador-page-header-title {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.jornada-lavador-page-header-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

@media (max-width: 600px) {
  .jornada-lavador-page-header {
    align-items: flex-start;
  }

  .jornada-lavador-page-header-title {
    font-size: 20px;
  }

  .jornada-lavador-page-header-subtitle {
    font-size: 13px;
  }
}
</style>
