import { createI18n } from 'vue-i18n'
import nl from './nl'
import en from './en'

export default createI18n({
  legacy: false,
  locale: localStorage.getItem('lang') || 'nl',
  fallbackLocale: 'en',
  messages: { nl, en }
})
