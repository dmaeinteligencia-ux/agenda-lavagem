<template>
  <header class="login-heading">
    <h2 class="login-heading-title">Acesse sua conta</h2>
    <p class="login-heading-subtitle">
      Entre com suas credenciais para acessar o sistema.
    </p>
  </header>
</template>

<style scoped>
.login-heading {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.login-heading-title {
  font-size: 24px;
  font-weight: 700;
  color: #1f2937;
  margin: 0;
}

.login-heading-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
}

@media (max-width: 480px) {
  .login-heading-title {
    font-size: 20px;
  }

  .login-heading-subtitle {
    font-size: 13px;
  }
}
</style>