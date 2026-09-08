<template>
  <div class="tipos-veiculo-form">
    <div class="tipos-veiculo-form-field">
      <label class="tipos-veiculo-form-label" for="tipos-veiculo-desc">Tipo de veículo</label>
      <input
        id="tipos-veiculo-desc"
        type="text"
        placeholder="Ex.: Caminhão"
        class="tipos-veiculo-form-input"
      />
    </div>

    <div class="tipos-veiculo-form-field">
      <label class="tipos-veiculo-form-label" for="tipos-veiculo-tempo">Tempo de lavagem</label>
      <div class="tipos-veiculo-form-tempo-wrapper">
        <input
          id="tipos-veiculo-tempo"
          type="number"
          placeholder="90"
          class="tipos-veiculo-form-input"
        />
        <span class="tipos-veiculo-form-unidade">minutos</span>
      </div>
    </div>

    <p class="tipos-veiculo-form-auxilio">
      Informe o tempo estimado necessário para realizar a lavagem deste tipo de veículo.
    </p>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.tipos-veiculo-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.tipos-veiculo-form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.tipos-veiculo-form-label {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.tipos-veiculo-form-input {
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

.tipos-veiculo-input::placeholder {
  color: #9ca3af;
}

.tipos-veiculo-form-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.15);
}

.tipos-veiculo-form-unidade {
  margin-left: 8px;
  font-size: 14px;
  color: #6b7280;
}

.tipos-veiculo-form-auxilio {
  font-size: 12px;
  color: #9ca3af;
  margin-top: 4px;
}
</style>