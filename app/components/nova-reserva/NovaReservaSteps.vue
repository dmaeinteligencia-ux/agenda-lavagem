<template>
  <nav class="nova-reserva-steps" aria-label="Etapas da nova reserva">
    <ol class="nova-reserva-steps-list">
      <li
        v-for="(step, index) in steps"
        :key="step.label"
        class="nova-reserva-step"
        :class="{
          'nova-reserva-step--active': index === current,
          'nova-reserva-step--done': index < current
        }"
      >
        <span class="nova-reserva-step-number" aria-hidden="true">
          {{ index < current ? checkIcon : index + 1 }}
        </span>
        <span class="nova-reserva-step-label">{{ step.label }}</span>
      </li>
    </ol>
  </nav>
</template>

<script setup lang="ts">
import { CheckIcon } from '@heroicons/vue/24/outline'

interface StepItem {
  label: string
}

interface Props {
  steps: StepItem[]
  current: number
}

withDefaults(defineProps<Props>(), {
  current: 0
})

const checkIcon = '✓'
</script>

<style scoped>
.nova-reserva-steps {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 16px 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.nova-reserva-steps-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.nova-reserva-step {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #9ca3af;
  font-size: 13px;
  font-weight: 500;
}

.nova-reserva-step + .nova-reserva-step::before {
  content: '';
  width: 24px;
  height: 1px;
  background: #e5e7eb;
  margin: 0 8px 0 0;
  flex-shrink: 0;
}

.nova-reserva-step-number {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: #f3f4f6;
  color: #6b7280;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}

.nova-reserva-step--active {
  color: #004790;
  font-weight: 600;
}

.nova-reserva-step--active .nova-reserva-step-number {
  background: #004790;
  color: #fff;
}

.nova-reserva-step--done {
  color: #065f46;
}

.nova-reserva-step--done .nova-reserva-step-number {
  background: #d1fae5;
  color: #065f46;
}

@media (max-width: 600px) {
  .nova-reserva-steps {
    padding: 12px 16px;
  }

  .nova-reserva-step + .nova-reserva-step::before {
    width: 12px;
    margin-right: 4px;
  }

  .nova-reserva-step-label {
    font-size: 12px;
  }
}
</style>