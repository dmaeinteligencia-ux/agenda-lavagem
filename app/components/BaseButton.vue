<template>
  <button
    class="base-btn"
    :class="[
      `base-btn--${variant}`,
      { 'base-btn--disabled': disabled }
    ]"
    :disabled="disabled"
  >
    <slot />
  </button>
</template>

<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary' | 'ghost'
  disabled?: boolean
}

withDefaults(defineProps<Props>(), {
  variant: 'primary',
  disabled: false
})
</script>

<style scoped>
.base-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 600;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s, opacity 0.2s;
}

.base-btn--disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.base-btn--primary {
  background-color: #004790;
  color: #fff;
}

.base-btn--primary:hover:not(.base-btn--disabled) {
  background-color: #003570;
}

.base-btn--secondary {
  background-color: #fff;
  color: #004790;
  border: 2px solid #004790;
}

.base-btn--secondary:hover:not(.base-btn--disabled) {
  background-color: #e8f0fe;
}

.base-btn--ghost {
  background: transparent;
  color: #004790;
}

.base-btn--ghost:hover:not(.base-btn--disabled) {
  background-color: rgba(0, 71, 144, 0.08);
}
</style>