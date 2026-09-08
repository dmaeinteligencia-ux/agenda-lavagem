<template>
  <section class="login-panel">
    <LoginInstitutionalLogos />
    <div class="login-panel-inner">
      <LoginHeading />
      <LoginForm @submit="onSubmit">
        <LoginEmailField v-model="email" :disabled="isLoading" />
        <LoginPasswordField v-model="password" :disabled="isLoading" />
        <LoginSubmitButton :loading="isLoading" :disabled="isLoading" />
      </LoginForm>
      <div v-if="errorMessage" class="login-error" role="alert">
        <ExclamationCircleIcon class="error-icon" aria-hidden="true" />
        <span>{{ errorMessage }}</span>
      </div>
      <LoginAccessNotice />
      <LoginFooter />
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ExclamationCircleIcon } from '@heroicons/vue/24/outline'
import LoginInstitutionalLogos from './LoginInstitutionalLogos.vue'
import LoginHeading from './LoginHeading.vue'
import LoginForm from './LoginForm.vue'
import LoginEmailField from './LoginEmailField.vue'
import LoginPasswordField from './LoginPasswordField.vue'
import LoginSubmitButton from './LoginSubmitButton.vue'
import LoginAccessNotice from './LoginAccessNotice.vue'
import LoginFooter from './LoginFooter.vue'

const { signIn, isLoading, error } = useAuth()

const email = ref('')
const password = ref('')
const localError = ref<string | null>(null)

const errorMessage = computed(() => localError.value || error.value)

const onSubmit = async () => {
  localError.value = null

  if (!email.value || !password.value) {
    localError.value = 'Preencha e-mail e senha.'
    return
  }

  const result = await signIn({ email: email.value, password: password.value })

  if (!result.success) {
    localError.value = result.error?.message || 'Não foi possível entrar no sistema.'
  }
}
</script>

<style scoped>
.login-panel {
  background: #f5f7fa;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 32px 24px;
  min-height: 100vh;
  gap: 20px;
}

.login-panel-inner {
  width: 100%;
  max-width: 480px;
  background: #fff;
  border-radius: 16px;
  padding: 32px;
  display: flex;
  flex-direction: column;
  gap: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04), 0 4px 12px rgba(0, 0, 0, 0.03);
  border: 1px solid #e5e7eb;
}

.login-error {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px;
  background: #fee2e2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  color: #991b1b;
  font-size: 13px;
}

.error-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

@media (max-width: 1024px) {
  .login-panel {
    min-height: auto;
    padding: 24px 20px 32px;
    justify-content: flex-start;
  }
}

@media (max-width: 480px) {
  .login-panel {
    padding: 20px 16px 24px;
    gap: 16px;
  }

  .login-panel-inner {
    padding: 24px 20px;
    gap: 20px;
    border-radius: 12px;
  }
}
</style>