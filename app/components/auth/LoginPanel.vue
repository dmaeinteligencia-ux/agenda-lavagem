<template>
  <section class="login-panel">
    <LoginInstitutionalLogos />
    <div class="login-panel-inner">
      <div v-if="!notice" class="auth-tabs" role="tablist" aria-label="Opções de acesso">
        <button
          type="button"
          role="tab"
          :aria-selected="activeTab === 'login'"
          class="auth-tab"
          :class="{ 'auth-tab--active': activeTab === 'login' }"
          @click="selectTab('login')"
        >
          Entrar
        </button>
        <button
          type="button"
          role="tab"
          :aria-selected="activeTab === 'signup'"
          class="auth-tab"
          :class="{ 'auth-tab--active': activeTab === 'signup' }"
          @click="selectTab('signup')"
        >
          Solicitar cadastro
        </button>
      </div>

      <AuthNotice
        v-if="notice"
        :variant="notice"
        :needs-email-confirmation="needsEmailConfirmation"
        @action="handleNoticeAction"
      />

      <template v-else-if="activeTab === 'login'">
        <LoginHeading />
        <LoginForm @submit="onSubmitLogin">
          <LoginEmailField v-model="email" :disabled="isLoading" />
          <LoginPasswordField v-model="password" :disabled="isLoading" />
          <LoginSubmitButton :loading="isLoading" :disabled="isLoading" />
        </LoginForm>
        <div v-if="errorMessage" class="login-error" role="alert">
          <ExclamationCircleIcon class="error-icon" aria-hidden="true" />
          <span>{{ errorMessage }}</span>
        </div>
        <LoginAccessNotice />
      </template>

      <template v-else>
        <header class="signup-heading">
          <h2 class="signup-heading-title">Solicite seu cadastro</h2>
          <p class="signup-heading-subtitle">
            Preencha seus dados para solicitar acesso ao sistema.
          </p>
        </header>
        <SignupForm
          :loading="isLoading"
          :disabled="isLoading"
          :api-error="signupError"
          @submit="onSubmitSignup"
        />
      </template>

      <LoginFooter />
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { ExclamationCircleIcon } from '@heroicons/vue/24/outline'
import LoginInstitutionalLogos from './LoginInstitutionalLogos.vue'
import LoginHeading from './LoginHeading.vue'
import LoginForm from './LoginForm.vue'
import LoginEmailField from './LoginEmailField.vue'
import LoginPasswordField from './LoginPasswordField.vue'
import LoginSubmitButton from './LoginSubmitButton.vue'
import LoginAccessNotice from './LoginAccessNotice.vue'
import LoginFooter from './LoginFooter.vue'
import SignupForm from './SignupForm.vue'
import AuthNotice from './AuthNotice.vue'

type NoticeVariant = 'PENDENTE' | 'BLOQUEADO' | 'SEM_PERFIL' | 'SIGNUP_SUCCESS'

const { signIn, signUp, signOut, isLoading } = useAuth()

const activeTab = ref<'login' | 'signup'>('login')
const notice = ref<NoticeVariant | null>(null)
const needsEmailConfirmation = ref(false)

const email = ref('')
const password = ref('')
const localError = ref<string | null>(null)
const signupError = ref<string | null>(null)

const errorMessage = computed(() => localError.value)

const selectTab = (tab: 'login' | 'signup') => {
  activeTab.value = tab
  localError.value = null
  signupError.value = null
}

const onSubmitLogin = async () => {
  localError.value = null

  if (!email.value || !password.value) {
    localError.value = 'Preencha e-mail e senha.'
    return
  }

  const result = await signIn({ email: email.value, password: password.value })

  if (result.success) {
    return
  }

  if (result.status === 'PENDENTE' || result.status === 'BLOQUEADO' || result.status === 'SEM_PERFIL') {
    notice.value = result.status
    return
  }

  localError.value = result.message || 'Não foi possível entrar no sistema.'
}

const onSubmitSignup = async (data: { nome: string; email: string; password: string }) => {
  signupError.value = null

  const result = await signUp(data)

  if (result.success) {
    needsEmailConfirmation.value = result.needsEmailConfirmation
    notice.value = 'SIGNUP_SUCCESS'
    return
  }

  signupError.value = result.message || 'Não foi possível concluir o cadastro.'
}

const handleNoticeAction = async () => {
  await signOut()
  notice.value = null
  needsEmailConfirmation.value = false
  activeTab.value = 'login'
  email.value = ''
  password.value = ''
  localError.value = null
  signupError.value = null
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

.auth-tabs {
  display: flex;
  gap: 4px;
  background: #f0f4f8;
  border-radius: 10px;
  padding: 4px;
}

.auth-tab {
  flex: 1;
  padding: 10px 16px;
  font-size: 14px;
  font-weight: 600;
  color: #4b5563;
  background: transparent;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, color 0.2s;
}

.auth-tab:hover {
  color: #004790;
}

.auth-tab--active {
  background: #fff;
  color: #004790;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
}

.auth-tab:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
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

.signup-heading {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.signup-heading-title {
  font-size: 24px;
  font-weight: 700;
  color: #1f2937;
  margin: 0;
}

.signup-heading-subtitle {
  font-size: 14px;
  color: #6b7280;
  margin: 0;
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

  .signup-heading-title {
    font-size: 20px;
  }
}
</style>
