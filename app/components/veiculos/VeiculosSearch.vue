<template>
  <div class="veiculos-search">
    <label for="veiculos-search" class="veiculos-search-label">Pesquisar</label>
    <div class="veiculos-search-input-wrap">
      <MagnifyingGlassIcon class="veiculos-search-icon" aria-hidden="true" />
      <input
        id="veiculos-search"
        class="veiculos-search-input"
        type="text"
        placeholder="Pesquisar por placa ou identificação..."
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { MagnifyingGlassIcon } from '@heroicons/vue/24/outline'
</script>

<style scoped>
.veiculos-search {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
  min-width: 200px;
}

.veiculos-search-label {
  font-size: 12px;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.veiculos-search-input-wrap {
  position: relative;
}

.veiculos-search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: #9ca3af;
  pointer-events: none;
}

.veiculos-search-input {
  width: 100%;
  padding: 10px 12px 10px 38px;
  font-size: 14px;
  color: #1f2937;
  background: #fff;
  border: 1.5px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.veiculos-search-input::placeholder {
  color: #9ca3af;
}

.veiculos-search-input:focus {
  border-color: #004790;
  box-shadow: 0 0 0 3px rgba(0, 71, 144, 0.1);
}
</style>