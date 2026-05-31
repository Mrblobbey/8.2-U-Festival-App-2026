<script setup>
import { ref, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import QRCode from 'qrcode'

const { t, locale } = useI18n()
const news = ref([])
const loading = ref(true)
const qrCanvas = ref(null)
const appUrl = window.location.origin

async function fetchNews() {
  loading.value = true
  const res = await fetch('/api/news')
  news.value = await res.json()
  loading.value = false
}

onMounted(async () => {
  await fetchNews()
  if (qrCanvas.value) {
    await QRCode.toCanvas(qrCanvas.value, appUrl, { width: 160, margin: 1, color: { dark: '#000000', light: '#ffffff' } })
  }
})

function formatDate(dateStr) {
  return new Date(dateStr).toLocaleString(locale.value === 'nl' ? 'nl-NL' : 'en-GB', {
    day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit'
  })
}
</script>

<template>
  <div class="page">
    <h1 class="page-title">{{ t('home.title') }}</h1>

    <div v-if="loading" class="loading">
      <span class="material-symbols-outlined spin">progress_activity</span>
    </div>

    <div v-else-if="news.length === 0" class="empty">{{ t('home.noNews') }}</div>

    <div class="card qr-card">
      <h2 class="qr-title">{{ locale === 'nl' ? 'Installeer de app' : 'Install the app' }}</h2>
      <p class="qr-sub">{{ locale === 'nl' ? 'Scan de QR-code om de app op je telefoon te installeren.' : 'Scan the QR code to install the app on your phone.' }}</p>
      <canvas ref="qrCanvas" class="qr-canvas"></canvas>
      <a :href="appUrl" class="qr-link">{{ appUrl }}</a>
    </div>

    <TransitionGroup name="slide-up" tag="div">
      <article v-for="item in news" :key="item.id" class="card news-card">
        <div class="news-card__meta">
          <span class="material-symbols-outlined news-icon">campaign</span>
          <time>{{ formatDate(item.created_at) }}</time>
        </div>
        <h2 class="news-card__title">{{ locale === 'nl' ? item.title_nl : item.title_en }}</h2>
        <p class="news-card__body">{{ locale === 'nl' ? item.content_nl : item.content_en }}</p>
      </article>
    </TransitionGroup>
  </div>
</template>

<style scoped>
.loading {
  display: flex;
  justify-content: center;
  padding: 2rem;
  color: var(--color-text-muted);
}
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.empty {
  text-align: center;
  color: var(--color-text-muted);
  padding: 2rem;
}

.news-card__meta {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.78rem;
  color: var(--color-text-muted);
  margin-bottom: 0.4rem;
}
.news-icon { font-size: 1rem; color: var(--color-accent); }
.news-card__title {
  font-size: 1rem;
  font-weight: 700;
  color: var(--color-text);
  margin-bottom: 0.4rem;
}
.news-card__body {
  font-size: 0.9rem;
  line-height: 1.5;
  color: var(--color-text-muted);
}

.slide-up-enter-active { transition: all 0.3s ease; }
.slide-up-enter-from { opacity: 0; transform: translateY(12px); }

.qr-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  text-align: center;
  margin-bottom: 1.25rem;
}
.qr-title {
  font-size: 1rem;
  font-weight: 700;
  color: var(--color-secondary);
}
.qr-sub {
  font-size: 0.82rem;
  color: var(--color-text-muted);
}
.qr-canvas {
  border-radius: 8px;
  border: 3px solid var(--color-accent);
}
.qr-link {
  font-size: 0.75rem;
  color: var(--color-accent);
  word-break: break-all;
}
</style>
