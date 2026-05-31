<script setup>
import { ref, computed, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores/app'

const { t } = useI18n()
const store = useAppStore()

const schedule = ref([])
const stages = ref([])
const selectedAct = ref(null)
const loading = ref(true)
const activeDay = ref(0)

const HOUR_WIDTH = 100
const ROW_HEIGHT = 80
const START_HOUR = 10
const END_HOUR = 24
const TOTAL_HOURS = END_HOUR - START_HOUR

const DAYS = [
  { label_nl: 'Zaterdag', label_en: 'Saturday', date: '2026-09-05' },
  { label_nl: 'Zondag',   label_en: 'Sunday',   date: '2026-09-06' }
]

async function fetchData() {
  const [schedRes, stageRes] = await Promise.all([
    fetch('/api/schedule'),
    fetch('/api/stages')
  ])
  schedule.value = await schedRes.json()
  stages.value = await stageRes.json()
  loading.value = false
}
onMounted(fetchData)

const activeDate = computed(() => DAYS[activeDay.value].date)

const filteredSchedule = computed(() =>
  schedule.value.filter(s => s.start_time.startsWith(activeDate.value))
)

function minutesSinceStart(dateStr) {
  const d = new Date(dateStr)
  return (d.getHours() - START_HOUR) * 60 + d.getMinutes()
}

function durationMinutes(start, end) {
  return (new Date(end) - new Date(start)) / 60000
}

function blockStyle(item) {
  const left = (minutesSinceStart(item.start_time) / 60) * HOUR_WIDTH
  const width = (durationMinutes(item.start_time, item.end_time) / 60) * HOUR_WIDTH
  return { left: left + 'px', width: (width - 4) + 'px' }
}

function formatTime(dateStr) {
  return new Date(dateStr).toLocaleTimeString('nl-NL', { hour: '2-digit', minute: '2-digit' })
}

const hours = computed(() => {
  const h = []
  for (let i = START_HOUR; i <= END_HOUR; i++) h.push(i)
  return h
})

function scheduleForStage(stageId) {
  return filteredSchedule.value.filter(s => s.stage_id === stageId)
}

function openAct(item) { selectedAct.value = item }
function closeModal() { selectedAct.value = null }
</script>

<template>
  <div class="schedule-page page">
    <h1 class="page-title">{{ t('schedule.title') }}</h1>

    <div class="day-tabs">
      <button
        v-for="(day, i) in DAYS"
        :key="i"
        class="day-tab"
        :class="{ 'day-tab--active': activeDay === i }"
        @click="activeDay = i"
      >
        {{ $i18n.locale === 'nl' ? day.label_nl : day.label_en }}
      </button>
    </div>

    <div v-if="loading" class="loading">
      <span class="material-symbols-outlined spin">progress_activity</span>
    </div>

    <div v-else class="schedule-wrapper">
      <div class="schedule-scroll">
        <!-- Tijdbalk -->
        <div class="time-header">
          <div class="stage-label-spacer"></div>
          <div class="time-ruler">
            <div v-for="h in hours" :key="h" class="time-tick" :style="{ width: HOUR_WIDTH + 'px' }">
              {{ h }}:00
            </div>
          </div>
        </div>

        <!-- Stage-rijen met verticaal gelabeld -->
        <div class="stage-rows">
          <div v-for="stage in stages" :key="stage.id" class="stage-row">
            <div class="stage-label">
              <span class="stage-label__text">{{ stage.name }}</span>
            </div>
            <div class="stage-track" :style="{ width: TOTAL_HOURS * HOUR_WIDTH + 'px', height: ROW_HEIGHT + 'px' }">
              <button
                v-for="item in scheduleForStage(stage.id)"
                :key="item.id"
                class="block"
                :class="{ 'block--favorite': store.isFavorite(item.id) }"
                :style="blockStyle(item)"
                @click="openAct(item)"
              >
                <span class="block__name">{{ item.act_name }}</span>
                <!-- Hart-icoon zoals in het ontwerp -->
                <svg class="block__heart" viewBox="0 0 24 24" width="12" height="12">
                  <path v-if="store.isFavorite(item.id)" fill="white" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                  <path v-else fill="none" stroke="white" stroke-width="2" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Act detail modal — slide-up sheet -->
    <Transition name="modal">
      <div v-if="selectedAct" class="modal-overlay" @click.self="closeModal">
        <div class="modal">
          <div v-if="selectedAct.image_url" class="modal-img-wrap">
            <img :src="selectedAct.image_url" :alt="selectedAct.act_name" class="modal-img" />
            <button class="modal-close" @click="closeModal">
              <span class="material-symbols-outlined">arrow_back</span>
            </button>
          </div>
          <div v-else class="modal-img-placeholder">
            <button class="modal-close modal-close--dark" @click="closeModal">
              <span class="material-symbols-outlined">close</span>
            </button>
          </div>

          <div class="modal-body">
            <div class="modal-title-row">
              <h2 class="modal-title">{{ selectedAct.act_name }}</h2>
              <button class="heart-btn" @click="store.toggleFavorite(selectedAct.id)" :aria-label="t('schedule.favorite')">
                <svg class="heart-icon-svg" viewBox="0 0 24 24" width="28" height="28">
                  <path v-if="store.isFavorite(selectedAct.id)" fill="currentColor" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                  <path v-else fill="none" stroke="currentColor" stroke-width="2" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                </svg>
              </button>
            </div>
            <p class="modal-time">
              {{ selectedAct.stage_name }} · {{ formatTime(selectedAct.start_time) }}–{{ formatTime(selectedAct.end_time) }}
            </p>
            <p class="modal-desc">{{ $i18n.locale === 'nl' && selectedAct.description_nl ? selectedAct.description_nl : selectedAct.description_en }}</p>
            <a v-if="selectedAct.youtube_url" :href="selectedAct.youtube_url" target="_blank" rel="noopener" class="btn">
              <span class="material-symbols-outlined">play_circle</span>
              YouTube
            </a>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.schedule-page { padding-bottom: 4rem; }

.day-tabs {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.day-tab {
  flex: 1;
  padding: 0.55rem;
  border-radius: 20px;
  border: none;
  background: var(--color-secondary);
  color: #fff;
  font-size: 0.9rem;
  font-weight: 700;
  font-style: italic;
  opacity: 0.5;
  transition: opacity 0.2s;
}
.day-tab--active { opacity: 1; background: #000; }

.loading {
  display: flex;
  justify-content: center;
  padding: 2rem;
  color: var(--color-text-muted);
}
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.schedule-wrapper {
  overflow: hidden;
  border-radius: var(--radius);
  border: 1px solid var(--color-border);
}

.schedule-scroll {
  overflow: auto;
  -webkit-overflow-scrolling: touch;
}

.time-header {
  display: flex;
  position: sticky;
  top: 0;
  z-index: 10;
  background: var(--color-bg);
  border-bottom: 1px solid var(--color-border);
}

.stage-label-spacer { min-width: 46px; width: 46px; flex-shrink: 0; }

.time-ruler { display: flex; }
.time-tick {
  font-size: 0.65rem;
  color: var(--color-secondary);
  font-weight: 700;
  padding: 0.35rem 0.2rem;
  border-left: 1px solid var(--color-border);
  flex-shrink: 0;
}

.stage-rows { display: flex; flex-direction: column; }
.stage-row {
  display: flex;
  border-top: 1px solid var(--color-border);
}

/* Verticaal stage-label zoals in het ontwerp */
.stage-label {
  min-width: 46px;
  width: 46px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-bg);
  position: sticky;
  left: 0;
  z-index: 5;
  border-right: 1px solid var(--color-border);
}
.stage-label__text {
  font-size: 0.7rem;
  font-weight: 700;
  color: var(--color-secondary);
  writing-mode: vertical-rl;
  text-orientation: mixed;
  transform: rotate(180deg);
  white-space: nowrap;
}

.stage-track { position: relative; flex-shrink: 0; }

/* Cerulean blokken zoals in het ontwerp */
.block {
  position: absolute;
  top: 8px;
  bottom: 8px;
  border-radius: 8px;
  padding: 0.4rem 0.5rem;
  border: none;
  cursor: pointer;
  text-align: left;
  overflow: hidden;
  background: var(--color-secondary);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  transition: transform 0.15s;
}
.block:active { transform: scale(0.97); }
.block--favorite { outline: 2px solid var(--color-info); }

.block__name {
  font-size: 0.78rem;
  font-weight: 700;
  font-style: italic;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.block__heart {
  font-size: 0.9rem;
  color: #fff;
  align-self: flex-end;
}

/* Modal — z-index hoger dan bottom-nav (200) zodat modal er altijd bovenop zit */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  z-index: 1000;
  display: flex;
  align-items: flex-end;
}

.modal {
  background: var(--color-bg);
  border-radius: 16px 16px 0 0;
  width: 100%;
  max-height: 88dvh;
  overflow-y: auto;
}

.modal-img-wrap {
  position: relative;
  width: 100%;
  height: 220px;
  overflow: hidden;
}
.modal-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.modal-img-placeholder { height: 16px; }

.modal-close {
  position: absolute;
  top: 0.6rem;
  left: 0.6rem;
  background: rgba(0,0,0,0.45);
  border: none;
  color: #fff;
  border-radius: 50%;
  padding: 0.2rem;
  display: flex;
  z-index: 1;
  cursor: pointer;
}
.modal-close--dark {
  position: static;
  background: transparent;
  color: var(--color-text-muted);
  align-self: flex-end;
  margin: 0.5rem 0.5rem 0 auto;
  display: flex;
}

.modal-body { padding: 1rem 1.25rem 1.5rem; }

.modal-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.25rem;
}

.modal-title {
  font-size: 1.4rem;
  font-weight: 700;
  color: var(--color-secondary);
}

.heart-btn {
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  padding: 0;
}
.heart-icon-svg { color: var(--color-accent); }

.modal-time {
  font-size: 0.82rem;
  color: var(--color-text-muted);
  margin-bottom: 0.75rem;
}

.modal-desc {
  font-size: 0.9rem;
  line-height: 1.6;
  color: var(--color-text-muted);
  margin-bottom: 1rem;
}

.modal-enter-active, .modal-leave-active { transition: all 0.25s ease; }
.modal-enter-from, .modal-leave-to { opacity: 0; transform: translateY(100%); }
</style>
