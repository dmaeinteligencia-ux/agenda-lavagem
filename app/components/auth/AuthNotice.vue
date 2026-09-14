<template>
  <div class="auth-notice" role="status">
    <component :is="icon" class="notice-icon" aria-hidden="true" />
    <h2 class="notice-title">{{ title }}</h2>
    <p class="notice-message">{{ message }}</p>
    <button type="button" class="notice-btn" @click="$emit('action')">
      {{ buttonLabel }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ClockIcon, NoSymbolIcon, UserCircleIcon, CheckCircleIcon } from '@heroicons/vue/24/outline'

interface Props {
  variant: 'PENDENTE' | 'BLOQUEADO' | 'SEM_PERFIL' | 'SIGNUP_SUCCESS'
  needsEmailConfirmation?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  needsEmailConfirmation: false
})

defineEmits<{
  action: []
}>()

const content = computed(() => {
  switch (props.variant) {
    case 'PENDENTE':
      return {
        icon: ClockIcon,
        title: 'Cadastro aguardando aprovação',
        message: 'Seu cadastro foi recebido e está aguardando liberação de um administrador.',
        buttonLabel: 'Sair'
      }
    case 'BLOQUEADO':
      return {
        icon: NoSymbolIcon,
        title: 'Acesso bloqueado',
        message: 'Seu acesso ao sistema está bloqueado. Procure um administrador.',
        buttonLabel: 'Sair'
      }
    case 'SEM_PERFIL':
      return {
        icon: UserCircleIcon,
        title: 'Acesso indisponível',
        message: 'Seu usuário não possui um perfil configurado. Entre em contato com o administrador.',
        buttonLabel: 'Sair'
      }
    case 'SIGNUP_SUCCESS':
      return {
        icon: CheckCircleIcon,
        title: 'Cadastro realizado com sucesso',
        message: props.needsEmailConfirmation
          ? 'Seu cadastro foi recebido. Verifique seu e-mail para confirmar a conta e, em seguida, aguarde a aprovação de um administrador.'
          : 'Seu cadastro foi recebido e está aguardando aprovação de um administrador.',
        buttonLabel: 'Voltar ao login'
      }
  }
})

const icon = computed(() => content.value.icon)
const title = computed(() => content.value.title)
const message = computed(() => content.value.message)
const buttonLabel = computed(() => content.value.buttonLabel)
</script>

<style scoped>
.auth-notice {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 12px;
  padding: 8px 0;
}

.notice-icon {
  width: 40px;
  height: 40px;
  color: #004790;
}

.notice-title {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
  color: #1f2937;
}

.notice-message {
  margin: 0;
  font-size: 14px;
  color: #6b7280;
  line-height: 1.5;
  max-width: 360px;
}

.notice-btn {
  margin-top: 8px;
  padding: 12px 24px;
  font-size: 14px;
  font-weight: 600;
  color: #004790;
  background: #fff;
  border: 1px solid #004790;
  border-radius: 8px;
  cursor: pointer;
  font-family: inherit;
  transition: background-color 0.2s, color 0.2s;
}

.notice-btn:hover {
  background: #e8f0fe;
}

.notice-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.25);
}
</style>
