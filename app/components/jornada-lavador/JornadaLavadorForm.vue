<template>
  <div class="jornada-lavador-form">
    <div class="jornada-lavador-form-field">
      <label class="jornada-lavador-form-label" for="jornada-regime">Regime</label>
      <select id="jornada-regime" class="jornada-lavador-form-select">
        <option value="NORMAL">NORMAL</option>
        <option value="PLANTAO">PLANTAO</option>
      </select>
    </div>

    <div class="jornada-lavador-form-field">
      <label class="jornada-lavador-form-label" for="jornada-horas">Horas disponíveis</label>
      <input
        id="jornada-horas"
        type="number"
        placeholder="8"
        class="jornada-lavador-form-input"
      />
      <span class="jornada-lavador-form-unidade">horas</span>
      <p class="jornada-lavador-form-auxilio">
        Informar a quantidade de horas disponíveis para este regime.
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.jornada-lavador-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.jornada-lavador-form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.jornada-lavador-form-label {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.jornada-lavador-form-input {
  width: 100%;
  padding: 10px 12px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 2px solid #d1d5db;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  font-family: inherit;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.jornada-lavador-form-input::placeholder {
  color: #9ca3af;
}

.jornada-lavador-form-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.jornada-lavador-form-unidade {
  margin-left: 8px;
  font-size: 14px;
  color: #6b7280;
}

.jornada-lavador-form-auxilio {
  font-size: 12px;
  color: #9ca3af;
  margin-top: 4px;
}
</style>