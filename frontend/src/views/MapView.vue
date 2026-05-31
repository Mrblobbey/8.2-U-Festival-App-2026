<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useI18n } from 'vue-i18n'
import L from 'leaflet'

const { t, locale } = useI18n()

const mapContainer = ref(null)
let map = null
let userMarker = null
let watchId = null

const stages = ref([])
const schedule = ref([])
const activeStage = ref(null)
const activePOI = ref(null)
const loading = ref(true)
const gpsActive = ref(false)
const legendaOpen = ref(false)

const stageImages = {
  'Ponton':   '/images/stages/ponton.png',
  'The Lake': '/images/stages/thelake.png',
  'The Club': '/images/stages/theclub.png',
  'Hangar':   '/images/stages/hangar.png',
}

// Vaste volgorde voor legenda + nummering (1–4)
const STAGE_ORDER = ['Ponton', 'The Lake', 'The Club', 'Hangar']

const sortedStages = computed(() =>
  [...stages.value].sort(
    (a, b) => STAGE_ORDER.indexOf(a.name) - STAGE_ORDER.indexOf(b.name)
  )
)

// Gecorrigeerde POI-coördinaten (SVG content-hoogte 1203.5, niet 1353.19)
const pois = [
  { type: 'wc',      lat: 52.075482, lng: 5.092634 },
  { type: 'wc',      lat: 52.070467, lng: 5.081975 },
  { type: 'wc',      lat: 52.075154, lng: 5.087115 },
  { type: 'wc',      lat: 52.071944, lng: 5.082516 },
  { type: 'wc',      lat: 52.073689, lng: 5.085407 },
  { type: 'merch',   lat: 52.070462, lng: 5.083181 },
  { type: 'merch',   lat: 52.074106, lng: 5.089178 },
  { type: 'merch',   lat: 52.074075, lng: 5.084965 },
  { type: 'ehbo',    lat: 52.074945, lng: 5.083272 },
  { type: 'ehbo',    lat: 52.076120, lng: 5.091386 },
  { type: 'ehbo',    lat: 52.074712, lng: 5.088823 },
  { type: 'ehbo',    lat: 52.073888, lng: 5.085897 },
  { type: 'ehbo',    lat: 52.071538, lng: 5.084298 },
  { type: 'bar',     lat: 52.075184, lng: 5.091129 },
  { type: 'bar',     lat: 52.075110, lng: 5.090001 },
  { type: 'bar',     lat: 52.073997, lng: 5.087419 },
  { type: 'bar',     lat: 52.070920, lng: 5.082471 },
  { type: 'lockers', lat: 52.070069, lng: 5.083999 },
  { type: 'lockers', lat: 52.070179, lng: 5.084795 },
]

// SVG-icoonpaden per POI-type
const POI_ICONS = {
  wc:      'M7 11h2v2H7zm0 4h2v2H7zm4-4h2v2h-2zm0 4h2v2h-2zm-1-9h2V4h3V2H7v2h3v2zm5 2H5c-1.1 0-2 .9-2 2v7c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2v-7c0-1.1-.9-2-2-2zm0 9H5v-7h10v7z',
  merch:   'M18 6h-2c0-2.21-1.79-4-4-4S8 3.79 8 6H6c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm-6-2c1.1 0 2 .9 2 2h-4c0-1.1.9-2 2-2zm6 16H6V8h2v2c0 .55.45 1 1 1s1-.45 1-1V8h4v2c0 .55.45 1 1 1s1-.45 1-1V8h2v12z',
  bar:     'M20 3H4v2l6.5 9v5H7v2h10v-2h-3.5v-5L20 5V3zm-3.67 5H7.67L5.9 5h12.2l-1.77 3z',
  ehbo:    'M19 3H5c-1.1 0-1.99.9-1.99 2L3 19c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-1 11h-4v4h-4v-4H6v-4h4V6h4v4h4v4z',
  lockers: 'M12 1C9.24 1 7 3.24 7 6v1H5c-1.1 0-2 .9-2 2v11c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V9c0-1.1-.9-2-2-2h-2V6c0-2.76-2.24-5-5-5zm0 2c1.66 0 3 1.34 3 3v1H9V6c0-1.66 1.34-3 3-3zm0 10c1.1 0 2 .9 2 2s-.9 2-2 2-2-.9-2-2 .9-2 2-2z',
}

// Accentkleur per POI-type
const POI_COLORS = {
  wc:      '#247BA0',
  merch:   '#F03228',
  bar:     '#E6A817',
  ehbo:    '#157a21',
  lockers: '#6B3FA0',
}

async function fetchData() {
  const [stageRes, schedRes] = await Promise.all([
    fetch('/api/stages'),
    fetch('/api/schedule')
  ])
  stages.value = await stageRes.json()
  schedule.value = await schedRes.json()
  loading.value = false
  initMap()
}

function isNowPlaying(act) {
  const now = new Date()
  return new Date(act.start_time) <= now && new Date(act.end_time) >= now
}

function formatTime(d) {
  return new Date(d).toLocaleTimeString('nl-NL', { hour: '2-digit', minute: '2-digit' })
}

function formatDayLabel(dateStr) {
  const d = new Date(dateStr)
  const loc = locale.value === 'nl' ? 'nl-NL' : 'en-GB'
  return d.toLocaleDateString(loc, { weekday: 'long', day: 'numeric', month: 'long' })
}

function getStageSchedule(stageId) {
  const acts = schedule.value
    .filter(s => s.stage_id === stageId)
    .sort((a, b) => new Date(a.start_time) - new Date(b.start_time))

  const groups = {}
  acts.forEach(act => {
    const key = formatDayLabel(act.start_time)
    if (!groups[key]) groups[key] = []
    groups[key].push(act)
  })
  return groups
}

function hasSchedule(stageId) {
  return schedule.value.some(s => s.stage_id === stageId)
}

function userIcon() {
  return L.divIcon({
    className: '',
    html: `<div style="
      width:18px;height:18px;border-radius:50%;
      background:#247BA0;border:3px solid #fff;
      box-shadow:0 0 0 5px rgba(36,123,160,0.25);
    "></div>`,
    iconSize: [18, 18],
    iconAnchor: [9, 9]
  })
}

function initMap() {
  if (!mapContainer.value || map) return

  // Ondergrens aangepast: SVG content eindigt op y=1203.5, niet de volledige hoogte 1353.19
  const festivalBounds = [[52.068468, 5.081], [52.0778, 5.0935]]
  const center = [52.0731, 5.0873]

  map = L.map(mapContainer.value, {
    center,
    zoom: 16,
    minZoom: 14,
    maxZoom: 19,
    zoomControl: false,
    maxBounds: [[52.065, 5.074], [52.083, 5.101]],
    maxBoundsViscosity: 0.8
  })

  L.imageOverlay('/images/kaart/kaart_festival_markers.svg', festivalBounds, {
    opacity: 1,
    interactive: false,
    zIndex: 1
  }).addTo(map)

  L.control.zoom({ position: 'topright' }).addTo(map)

  // Podium-klikgebieden (radius 35 = 70px diameter touch target)
  stages.value.forEach(stage => {
    if (!stage.lat || !stage.lng) return
    L.circleMarker([stage.lat, stage.lng], {
      radius: 35,
      color: 'transparent',
      weight: 0,
      fillColor: '#ffffff',
      fillOpacity: 0.01,
      interactive: true,
      bubblingMouseEvents: false,
    }).addTo(map).on('click', () => {
      activePOI.value = null
      activeStage.value = stage
    })
  })

  // Faciliteiten-klikgebieden (radius 22 = 44px diameter)
  pois.forEach(poi => {
    L.circleMarker([poi.lat, poi.lng], {
      radius: 22,
      color: 'transparent',
      weight: 0,
      fillColor: '#ffffff',
      fillOpacity: 0.01,
      interactive: true,
      bubblingMouseEvents: false,
    }).addTo(map).on('click', () => {
      activeStage.value = null
      activePOI.value = poi
    })
  })
}

function toggleGPS() {
  gpsActive.value ? stopGPS() : startGPS()
}

function startGPS() {
  if (!navigator.geolocation) return
  gpsActive.value = true
  watchId = navigator.geolocation.watchPosition(
    ({ coords }) => {
      const latlng = [coords.latitude, coords.longitude]
      if (userMarker) {
        userMarker.setLatLng(latlng)
      } else {
        userMarker = L.marker(latlng, { icon: userIcon(), zIndexOffset: 200 }).addTo(map)
      }
      map.setView(latlng, map.getZoom())
    },
    () => { gpsActive.value = false },
    { enableHighAccuracy: true }
  )
}

function stopGPS() {
  if (watchId) navigator.geolocation.clearWatch(watchId)
  if (userMarker) { userMarker.remove(); userMarker = null }
  gpsActive.value = false
  watchId = null
}

onMounted(fetchData)
onUnmounted(() => {
  stopGPS()
  if (map) { map.remove(); map = null }
})
</script>

<template>
  <div class="map-page">
    <div v-if="loading" class="map-loading">
      <span class="material-symbols-outlined spin">progress_activity</span>
    </div>

    <div ref="mapContainer" class="leaflet-map"></div>

    <!-- GPS-knop linksonder — position:fixed zodat het altijd boven de nav hangt -->
    <button
      class="map-fab gps-fab"
      :class="{ 'map-fab--active': gpsActive }"
      @click="toggleGPS"
      :title="gpsActive ? t('map.yourLocation') : 'GPS'"
    >
      <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
        <path d="M12 8c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm8.94 3A8.994 8.994 0 0013 3.06V1h-2v2.06A8.994 8.994 0 003.06 11H1v2h2.06A8.994 8.994 0 0011 20.94V23h2v-2.06A8.994 8.994 0 0020.94 13H23v-2h-2.06zM12 19c-3.87 0-7-3.13-7-7s3.13-7 7-7 7 3.13 7 7-3.13 7-7 7z"/>
      </svg>
      <span class="map-fab__label">{{ gpsActive ? t('map.yourLocation') : 'GPS' }}</span>
    </button>

    <!-- Legenda-knop rechtsonder — position:fixed zodat het altijd boven de nav hangt -->
    <button
      class="map-fab legend-fab"
      :class="{ 'map-fab--active': legendaOpen }"
      @click="legendaOpen = !legendaOpen"
      :title="t('map.legend')"
    >
      <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
        <path d="M3 13h2v-2H3v2zm0 4h2v-2H3v2zm0-8h2V7H3v2zm4 4h14v-2H7v2zm0 4h14v-2H7v2zM7 7v2h14V7H7z"/>
      </svg>
      <span class="map-fab__label">{{ t('map.legend') }}</span>
    </button>

    <!-- Legenda panel — custom Vue-legenda, volgt taal -->
    <Transition name="slide-up">
      <div v-if="legendaOpen" class="bottom-panel legend-panel">
        <div class="panel-drag-bar"></div>
        <div class="legend-header">
          <span class="legend-title-text">{{ t('map.legend') }}</span>
          <button class="panel-close" @click="legendaOpen = false">
            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        <!-- Podia -->
        <div class="legend-section-label">{{ t('map.stages') }}</div>
        <div class="legend-list">
          <div
            v-for="(stage, idx) in sortedStages"
            :key="stage.id"
            class="legend-item"
            @click="legendaOpen = false; activeStage = stage; activePOI = null"
          >
            <div class="legend-stage-dot" :style="{ background: stage.color || '#F03228' }">
              {{ idx + 1 }}
            </div>
            <span class="legend-item-label">{{ stage.name }}</span>
          </div>
        </div>

        <!-- Faciliteiten -->
        <div class="legend-section-label">{{ t('map.facilities') }}</div>
        <div class="legend-list">
          <div
            v-for="type in ['wc', 'merch', 'bar', 'ehbo', 'lockers']"
            :key="type"
            class="legend-item"
          >
            <div class="legend-poi-dot" :style="{ background: POI_COLORS[type] }">
              <svg viewBox="0 0 24 24" fill="white" width="14" height="14">
                <path :d="POI_ICONS[type]"/>
              </svg>
            </div>
            <span class="legend-item-label">{{ t(`map.${type}`) }}</span>
          </div>
        </div>
      </div>
    </Transition>

    <!-- POI infopaneel -->
    <Transition name="slide-up">
      <div v-if="activePOI" class="bottom-panel poi-panel">
        <div class="panel-drag-bar"></div>
        <div class="poi-header">
          <div class="poi-icon-wrap" :style="{ background: POI_COLORS[activePOI.type] }">
            <svg viewBox="0 0 24 24" fill="white" width="26" height="26">
              <path :d="POI_ICONS[activePOI.type]"/>
            </svg>
          </div>
          <div class="poi-text">
            <h2 class="poi-title">{{ t(`map.${activePOI.type}`) }}</h2>
            <p class="poi-desc">{{ t(`map.${activePOI.type}_desc`) }}</p>
          </div>
          <button class="panel-close" @click="activePOI = null">
            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>
      </div>
    </Transition>

    <!-- Stage info panel -->
    <Transition name="slide-up">
      <div v-if="activeStage" class="bottom-panel stage-info-panel">

        <!-- Podiumfoto met overlay -->
        <div v-if="stageImages[activeStage.name]" class="stage-photo-wrap">
          <img :src="stageImages[activeStage.name]" :alt="activeStage.name" class="stage-photo" />
          <div class="stage-photo-gradient"></div>
          <h2 class="stage-photo-title">{{ activeStage.name }}</h2>
          <button class="panel-close panel-close--photo" @click="activeStage = null">
            <svg viewBox="0 0 24 24" fill="white" width="16" height="16">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        <!-- Geen foto: fallback header -->
        <div v-else class="stage-header">
          <div class="panel-drag-bar"></div>
          <div class="stage-dot" :style="{ background: activeStage.color }"></div>
          <h2 class="stage-title">{{ activeStage.name }}</h2>
          <button class="panel-close" @click="activeStage = null">
            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
            </svg>
          </button>
        </div>

        <!-- Volledig programma per dag -->
        <div class="stage-body">
          <template v-if="hasSchedule(activeStage.id)">
            <template v-for="(acts, dayLabel) in getStageSchedule(activeStage.id)" :key="dayLabel">
              <div class="schedule-day-header">{{ dayLabel }}</div>
              <div
                v-for="act in acts"
                :key="act.id"
                class="schedule-act-row"
                :class="{ 'schedule-act--now': isNowPlaying(act) }"
              >
                <span class="schedule-act-time">{{ formatTime(act.start_time) }}</span>
                <span class="schedule-act-name">{{ act.act_name }}</span>
                <span v-if="isNowPlaying(act)" class="schedule-act-live">LIVE</span>
              </div>
            </template>
          </template>
          <div v-else class="schedule-empty">{{ t('schedule.noSchedule') }}</div>
        </div>

      </div>
    </Transition>
  </div>
</template>

<style scoped>
.map-page {
  position: relative;
  flex: 1;
  display: flex;
  flex-direction: column;
  height: calc(100dvh - 57px - 56px);
  overflow: hidden;
}

.leaflet-map {
  flex: 1;
  width: 100%;
  min-height: 0;
  background: #f2ecd3;
}

/* Loading */
.map-loading {
  position: absolute;
  inset: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #f2ecd3;
  z-index: 10;
}
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

/* FAB-knoppen — position:fixed zodat ze ALTIJD boven de bottom-nav zweven */
.map-fab {
  position: fixed;
  bottom: calc(56px + env(safe-area-inset-bottom, 0px) + 0.75rem);
  z-index: 800;
  background: var(--color-bg);
  border: 2px solid var(--color-border);
  border-radius: 24px;
  padding: 0.4rem 0.8rem 0.4rem 0.6rem;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  cursor: pointer;
  color: var(--color-text-muted);
  box-shadow: 0 2px 8px rgba(0,0,0,0.25);
  transition: border-color 0.2s, color 0.2s, background 0.2s;
}
.map-fab--active {
  border-color: var(--color-secondary);
  color: var(--color-secondary);
  background: rgba(36,123,160,0.08);
}
.map-fab__label {
  font-family: 'Sansation', sans-serif;
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: .02em;
}

.gps-fab    { left: 1rem; }
.legend-fab { right: 1rem; }
.legend-fab.map-fab--active { border-color: var(--color-accent); color: var(--color-accent); background: rgba(240,50,40,0.07); }

/* Gedeeld basis voor alle bottom-panels — position:fixed zodat ze boven de nav uitkomen */
.bottom-panel {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 900;
  background: var(--color-bg);
  border-radius: 16px 16px 0 0;
  box-shadow: 0 -4px 24px rgba(0,0,0,0.22);
  overflow: hidden;
  padding-bottom: env(safe-area-inset-bottom, 0px);
}

/* Sleep-balkje bovenaan panels */
.panel-drag-bar {
  width: 40px;
  height: 4px;
  border-radius: 2px;
  background: var(--color-border);
  margin: 0.5rem auto 0;
}

/* Legenda panel */
.legend-panel { max-height: 75dvh; overflow-y: auto; }
.legend-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem 1rem 0.5rem;
}
.legend-title-text {
  font-family: 'Sansation', sans-serif;
  font-size: 1rem;
  font-weight: 700;
  color: var(--color-text);
}
.legend-section-label {
  font-size: 0.7rem;
  font-weight: 700;
  color: var(--color-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  padding: 0.4rem 1rem 0.2rem;
}
.legend-list { padding: 0 1rem 0.5rem; }
.legend-item {
  display: flex;
  align-items: center;
  gap: 0.65rem;
  padding: 0.45rem 0;
  cursor: pointer;
}
.legend-stage-dot {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  color: #fff;
  font-family: 'Sansation', sans-serif;
  font-weight: 700;
  font-size: 0.8rem;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.legend-poi-dot {
  width: 28px;
  height: 28px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.legend-item-label {
  font-size: 0.88rem;
  font-weight: 600;
  color: var(--color-text);
}

/* POI panel */
.poi-panel { }
.poi-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
}
.poi-icon-wrap {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.poi-text { flex: 1; }
.poi-title { font-size: 1.05rem; font-weight: 700; color: var(--color-text); margin-bottom: 0.15rem; }
.poi-desc  { font-size: 0.82rem; color: var(--color-text-muted); line-height: 1.4; }

/* Stage info panel */
.stage-info-panel { max-height: 60dvh; }

.stage-photo-wrap {
  position: relative;
  width: 100%;
  height: 150px;
  overflow: hidden;
  flex-shrink: 0;
}
.stage-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center 40%;
  display: block;
}
.stage-photo-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.65) 0%, transparent 55%);
}
.stage-photo-title {
  position: absolute;
  bottom: 0.75rem;
  left: 1rem;
  font-size: 1.25rem;
  font-weight: 700;
  color: #fff;
  text-shadow: 0 1px 6px rgba(0,0,0,0.5);
}
.panel-close--photo {
  position: absolute;
  top: 0.6rem;
  right: 0.6rem;
  background: rgba(0,0,0,0.38);
  border: none;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.stage-header {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.5rem 1rem 1rem;
}
.stage-dot { width: 12px; height: 12px; border-radius: 50%; flex-shrink: 0; }
.stage-title { font-size: 1.1rem; font-weight: 700; color: var(--color-text); flex: 1; }

.panel-close {
  background: none;
  border: none;
  color: var(--color-text-muted);
  cursor: pointer;
  display: flex;
  padding: 0.2rem;
}

.stage-body {
  padding: 0.5rem 1rem 1.25rem;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  max-height: calc(60dvh - 150px);
}

.schedule-day-header {
  font-family: 'Sansation', sans-serif;
  font-size: 0.7rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-text-muted);
  padding: 0.6rem 0 0.3rem;
  border-bottom: 1px solid var(--color-border);
  margin-bottom: 0.25rem;
}
.schedule-day-header:first-child { padding-top: 0.2rem; }

.schedule-act-row {
  display: flex;
  align-items: center;
  gap: 0.65rem;
  padding: 0.45rem 0;
  border-bottom: 1px solid color-mix(in srgb, var(--color-border) 50%, transparent);
}
.schedule-act-row:last-child { border-bottom: none; }

.schedule-act--now {
  background: color-mix(in srgb, var(--color-accent) 8%, transparent);
  border-radius: 6px;
  margin: 0 -0.4rem;
  padding: 0.45rem 0.4rem;
}

.schedule-act-time {
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--color-text-muted);
  min-width: 2.8rem;
  flex-shrink: 0;
}
.schedule-act--now .schedule-act-time { color: var(--color-accent); }

.schedule-act-name {
  font-size: 0.88rem;
  font-weight: 600;
  color: var(--color-text);
  flex: 1;
}
.schedule-act--now .schedule-act-name { color: var(--color-text); }

.schedule-act-live {
  font-size: 0.62rem;
  font-weight: 700;
  letter-spacing: 0.06em;
  background: var(--color-accent);
  color: #fff;
  border-radius: 4px;
  padding: 0.1rem 0.35rem;
  flex-shrink: 0;
}

.schedule-empty {
  font-size: 0.88rem;
  color: var(--color-text-muted);
  padding: 0.75rem 0;
}

/* Leaflet zoom-knoppen */
:deep(.leaflet-control-zoom) { border: none !important; box-shadow: 0 2px 8px rgba(0,0,0,0.2) !important; }
:deep(.leaflet-control-zoom a) {
  background: var(--color-bg) !important;
  color: var(--color-text) !important;
  border: none !important;
  font-size: 18px !important;
  width: 36px !important;
  height: 36px !important;
  line-height: 36px !important;
}
:deep(.leaflet-control-zoom a:hover) { background: var(--color-accent) !important; color: #fff !important; }

/* Animaties */
.slide-up-enter-active, .slide-up-leave-active { transition: transform 0.28s ease; }
.slide-up-enter-from, .slide-up-leave-to { transform: translateY(100%); }
</style>
