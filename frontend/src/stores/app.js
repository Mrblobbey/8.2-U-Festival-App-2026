import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export const useAppStore = defineStore('app', () => {
  const darkMode = ref(localStorage.getItem('darkMode') === 'true')
  const favorites = ref(JSON.parse(localStorage.getItem('favorites') || '[]'))

  watch(darkMode, (val) => {
    localStorage.setItem('darkMode', val)
    document.documentElement.classList.toggle('dark', val)
  }, { immediate: true })

  watch(favorites, (val) => {
    localStorage.setItem('favorites', JSON.stringify(val))
  }, { deep: true })

  function toggleFavorite(scheduleId) {
    const idx = favorites.value.indexOf(scheduleId)
    if (idx === -1) favorites.value.push(scheduleId)
    else favorites.value.splice(idx, 1)
  }

  function isFavorite(scheduleId) {
    return favorites.value.includes(scheduleId)
  }

  return { darkMode, favorites, toggleFavorite, isFavorite }
})
