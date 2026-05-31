import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'home', component: HomeView },
    { path: '/info', name: 'info', component: () => import('@/views/InfoView.vue') },
    { path: '/schedule', name: 'schedule', component: () => import('@/views/ScheduleView.vue') },
    { path: '/map', name: 'map', component: () => import('@/views/MapView.vue') }
  ]
})

export default router
