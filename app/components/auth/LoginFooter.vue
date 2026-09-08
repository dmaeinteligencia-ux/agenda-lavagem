<template>
  <footer class="login-footer">
    <p class="footer-line footer-line--primary">DMAE — Departamento Municipal de Água e Esgoto</p>
    <p class="footer-line">Sistema de Gestão do Lavador</p>
  </footer>
</template>

<style scoped>
.login-footer {
  display: flex;
  flex-direction: column;
  gap: 2px;
  text-align: center;
  padding: 16px 0 0;
  border-top: 1px solid #f0f4f8;
}

.footer-line {
  font-size: 11px;
  color: #9ca3af;
  margin: 0;
  line-height: 1.4;
}

.footer-line--primary {
  font-weight: 600;
  color: #6b7280;
}
</style>