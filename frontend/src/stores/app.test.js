import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAppStore } from './app'

beforeEach(() => {
  localStorage.clear()
  setActivePinia(createPinia())
})

describe('useAppStore', () => {
  it('start zonder favorieten', () => {
    const store = useAppStore()
    expect(store.favorites).toHaveLength(0)
  })

  it('voegt favoriet toe en verwijdert het weer', () => {
    const store = useAppStore()
    store.toggleFavorite(1)
    expect(store.isFavorite(1)).toBe(true)
    store.toggleFavorite(1)
    expect(store.isFavorite(1)).toBe(false)
  })

  it('dark mode slaat op in localStorage', async () => {
    const store = useAppStore()
    store.darkMode = true
    await new Promise(r => setTimeout(r, 0))
    expect(localStorage.getItem('darkMode')).toBe('true')
  })

  it('favorieten blijven bewaard in localStorage', async () => {
    const store = useAppStore()
    store.toggleFavorite(5)
    store.toggleFavorite(7)
    await new Promise(r => setTimeout(r, 0))
    const saved = JSON.parse(localStorage.getItem('favorites'))
    expect(saved).toContain(5)
    expect(saved).toContain(7)
  })
})
