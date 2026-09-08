<template>
  <div class="layout">
    <HeaderBar />
    <div class="layout-body">
      <SidebarNav />
      <main class="content">
        <slot />
      </main>
    </div>
  </div>
</template>

<style scoped>
.layout {
  min-height: 100vh;
  background-color: #f0f4f8;
  display: flex;
  flex-direction: column;
}

.layout-body {
  display: flex;
  flex: 1;
  min-height: 0;
}

.content {
  flex: 1;
  padding: 24px;
  min-width: 0;
  overflow-x: hidden;
  overflow-y: auto;
  height: calc(100vh - 64px);
}

@media (max-width: 768px) {
  .layout-body {
    flex-direction: column;
  }

  .content {
    padding: 16px;
    height: auto;
  }
}
</style>