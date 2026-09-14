<template>
  <form class="signup-form" novalidate @submit.prevent="onSubmit">
    <div class="signup-field">
      <label for="signup-nome" class="signup-label">Nome</label>
      <div class="signup-input-wrapper">
        <UserIcon class="signup-icon" aria-hidden="true" />
        <input
          id="signup-nome"
          v-model="form.nome"
          type="text"
          name="name"
          class="signup-input"
          placeholder="Digite seu nome completo"
          autocomplete="name"
          :disabled="disabled"
        />
      </div>
      <span v-if="submitted && !form.nome.trim()" class="signup-error">Nome é obrigatório.</span>
    </div>

    <div class="signup-field">
      <label for="signup-email" class="signup-label">E-mail</label>
      <div class="signup-input-wrapper">
        <EnvelopeIcon class="signup-icon" aria-hidden="true" />
        <input
          id="signup-email"
          v-model="form.email"
          type="email"
          name="email"
          class="signup-input"
          placeholder="Digite seu e-mail"
          autocomplete="email"
          :disabled="disabled"
        />
      </div>
      <span v-if="submitted && !form.email.trim()" class="signup-error">E-mail é obrigatório.</span>
    </div>

    <div class="signup-field">
      <label for="signup-password" class="signup-label">Senha</label>
      <div class="signup-input-wrapper">
        <LockClosedIcon class="signup-icon" aria-hidden="true" />
        <input
          id="signup-password"
          v-model="form.password"
          :type="showPassword ? 'text' : 'password'"
          name="new-password"
          class="signup-input signup-input--password"
          placeholder="Crie uma senha"
          autocomplete="new-password"
          :disabled="disabled"
        />
        <button
          type="button"
          class="signup-toggle"
          :aria-label="showPassword ? 'Ocultar senha' : 'Mostrar senha'"
          :disabled="disabled"
          @click="showPassword = !showPassword"
        >
          <component :is="showPassword ? EyeSlashIcon : EyeIcon" aria-hidden="true" />
        </button>
      </div>
      <span v-if="submitted && !form.password" class="signup-error">Senha é obrigatória.</span>
    </div>

    <div class="signup-field">
      <label for="signup-confirm" class="signup-label">Confirmar senha</label>
      <div class="signup-input-wrapper">
        <LockClosedIcon class="signup-icon" aria-hidden="true" />
        <input
          id="signup-confirm"
          v-model="form.confirmPassword"
          :type="showPassword ? 'text' : 'password'"
          name="confirm-password"
          class="signup-input signup-input--password"
          placeholder="Repita a senha"
          autocomplete="new-password"
          :disabled="disabled"
        />
      </div>
      <span v-if="submitted && !form.confirmPassword" class="signup-error">Confirme sua senha.</span>
      <span v-else-if="submitted && form.password !== form.confirmPassword" class="signup-error">
        As senhas não coincidem.
      </span>
    </div>

    <p v-if="apiError" class="signup-api-error" role="alert">{{ apiError }}</p>

    <button type="submit" class="signup-submit" :disabled="disabled">
      <span v-if="loading" class="signup-spinner" aria-hidden="true" />
      {{ loading ? 'Enviando...' : 'Solicitar cadastro' }}
    </button>
  </form>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { UserIcon, EnvelopeIcon, LockClosedIcon, EyeIcon, EyeSlashIcon } from '@heroicons/vue/24/outline'

interface Props {
  loading?: boolean
  disabled?: boolean
  apiError?: string | null
}

withDefaults(defineProps<Props>(), {
  loading: false,
  disabled: false,
  apiError: null
})

const emit = defineEmits<{
  submit: [value: { nome: string; email: string; password: string }]
}>()

const form = reactive({
  nome: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const submitted = ref(false)
const showPassword = ref(false)

const isValid = () => {
  return (
    form.nome.trim() !== '' &&
    form.email.trim() !== '' &&
    form.password !== '' &&
    form.confirmPassword !== '' &&
    form.password === form.confirmPassword
  )
}

const onSubmit = () => {
  submitted.value = true

  if (!isValid()) {
    return
  }

  emit('submit', {
    nome: form.nome,
    email: form.email.trim(),
    password: form.password
  })
}
</script>

<style scoped>
.signup-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.signup-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.signup-label {
  font-size: 13px;
  font-weight: 600;
  color: #374151;
}

.signup-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.signup-icon {
  position: absolute;
  left: 14px;
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.signup-input {
  width: 100%;
  padding: 12px 14px 12px 42px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
  font-family: inherit;
}

.signup-input--password {
  padding-right: 44px;
}

.signup-input::placeholder {
  color: #9ca3af;
}

.signup-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}

.signup-input:disabled {
  background: #f3f4f6;
  cursor: not-allowed;
}

.signup-toggle {
  position: absolute;
  right: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  padding: 0;
  background: transparent;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  color: #9ca3af;
  transition: color 0.2s, background 0.2s;
}

.signup-toggle:hover:not(:disabled) {
  color: #004790;
  background: #f3f4f6;
}

.signup-toggle:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.signup-toggle svg {
  width: 18px;
  height: 18px;
}

.signup-error {
  font-size: 12px;
  color: #dc2626;
}

.signup-api-error {
  margin: 0;
  padding: 10px 12px;
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  border-radius: 8px;
  font-size: 13px;
}

.signup-submit {
  width: 100%;
  padding: 14px 20px;
  font-size: 15px;
  font-weight: 600;
  color: #fff;
  background-color: #004790;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, box-shadow 0.2s, transform 0.1s;
  margin-top: 4px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.signup-submit:hover:not(:disabled) {
  background-color: #003570;
}

.signup-submit:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.3);
}

.signup-submit:active:not(:disabled) {
  transform: translateY(1px);
}

.signup-submit:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
  opacity: 0.7;
}

.signup-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: signup-spin 0.6s linear infinite;
}

@keyframes signup-spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
