<script setup>
import { RouterLink, RouterView } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores/app'

const { locale, t } = useI18n()
const store = useAppStore()

function toggleLang() {
  locale.value = locale.value === 'nl' ? 'en' : 'nl'
  localStorage.setItem('lang', locale.value)
}
</script>

<template>
  <header class="app-header">
    <RouterLink to="/" class="app-header__logo">
      <img
        :src="store.darkMode ? '/images/logo/logo_white.svg' : '/images/logo/logo_white.svg'"
        alt="U Festival 2026"
        class="logo-img"
      />
    </RouterLink>
    <div class="app-header__controls">
      <button class="theme-btn" @click="store.darkMode = !store.darkMode" :aria-label="store.darkMode ? t('theme.light') : t('theme.dark')">
        <svg width="26" height="26" viewBox="0 0 28 28" fill="none">
          <circle cx="14" cy="14" r="12" stroke="white" stroke-width="2" fill="none"/>
          <path d="M14 2 A12 12 0 0 1 14 26 Z" fill="white"/>
        </svg>
      </button>
      <button class="lang-btn" @click="toggleLang" :aria-label="locale === 'nl' ? 'Switch to English' : 'Schakel naar Nederlands'">
        <span class="lang-label">{{ locale === 'nl' ? 'EN' : 'NL' }}</span>
      </button>
    </div>
  </header>

  <main>
    <RouterView v-slot="{ Component }">
      <Transition name="fade" mode="out-in">
        <component :is="Component" />
      </Transition>
    </RouterView>
  </main>

  <nav class="bottom-nav">
    <RouterLink to="/" class="bottom-nav__item">
      <svg class="nav-icon" viewBox="0 0 24 24" fill="currentColor">
        <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
      </svg>
    </RouterLink>
    <RouterLink to="/info" class="bottom-nav__item">
      <svg class="nav-icon" viewBox="0 0 24 24" fill="currentColor">
        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
      </svg>
    </RouterLink>
    <RouterLink to="/schedule" class="bottom-nav__item">
      <svg class="nav-icon" viewBox="0 0 24 24" fill="currentColor">
        <path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/>
      </svg>
    </RouterLink>
    <RouterLink to="/map" class="bottom-nav__item">
      <svg class="nav-icon" viewBox="0 0 24 24" fill="currentColor">
        <path d="M20.5 3l-.16.03L15 5.1 9 3 3.36 4.9c-.21.07-.36.25-.36.48V20.5c0 .28.22.5.5.5l.16-.03L9 18.9l6 2.1 5.64-1.9c.21-.07.36-.25.36-.48V3.5c0-.28-.22-.5-.5-.5zM15 19l-6-2.11V5l6 2.11V19z"/>
      </svg>
    </RouterLink>
  </nav>
</template>

<style scoped>
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.6rem 1rem;
  background: #000000;
  position: sticky;
  top: 0;
  z-index: 100;
}

.app-header__logo {
  display: flex;
  align-items: center;
  text-decoration: none;
}
.logo-img {
  height: 38px;
  width: auto;
}

.app-header__controls {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.theme-btn {
  background: transparent;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  padding: 0;
}

.lang-btn {
  background: transparent;
  border: 1.5px solid rgba(255,255,255,0.5);
  border-radius: 4px;
  cursor: pointer;
  padding: 0.2rem 0.5rem;
  display: flex;
  align-items: center;
}

.lang-label {
  font-family: 'Sansation', sans-serif;
  font-size: 0.75rem;
  font-weight: 700;
  color: #ffffff;
  letter-spacing: 0.05em;
}

main {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  background: var(--color-accent);
  z-index: 200;
  padding-bottom: env(safe-area-inset-bottom);
  height: 56px;
}

.bottom-nav__item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  color: rgba(255,255,255,0.6);
  transition: color 0.2s;
}

.nav-icon {
  width: 24px;
  height: 24px;
}

.bottom-nav__item.router-link-exact-active {
  color: #ffffff;
}

.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
