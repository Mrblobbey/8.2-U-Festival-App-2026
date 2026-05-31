<script setup>
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'

const { locale } = useI18n()
const open = ref(null)

// SVG path-data per sectie-icoon (eigen ontwerp, geen emoji)
const ICONS = {
  general:   'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z',
  transport: 'M4 16c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4s-8 .5-8 4v10zm3.5 1c-.83 0-1.5-.67-1.5-1.5S6.67 14 7.5 14s1.5.67 1.5 1.5S8.33 17 7.5 17zm9 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm1.5-6H6V6h12v5z',
  lockers:   'M12 1C9.24 1 7 3.24 7 6v1H5c-1.1 0-2 .9-2 2v11c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V9c0-1.1-.9-2-2-2h-2V6c0-2.76-2.24-5-5-5zm0 2c1.66 0 3 1.34 3 3v1H9V6c0-1.66 1.34-3 3-3zm0 10c1.1 0 2 .9 2 2s-.9 2-2 2-2-.9-2-2 .9-2 2-2z',
  faq:       'M11 18h2v-2h-2v2zm1-16C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-14c-2.21 0-4 1.79-4 4h2c0-1.1.9-2 2-2s2 .9 2 2c0 2-3 1.75-3 5h2c0-2.25 3-2.5 3-5 0-2.21-1.79-4-4-4z',
  golden:    'M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z',
}

// Transport-items per taal met eigen SVG-icoon per vervoersmiddel
const TRANSPORT_ICONS = {
  bike:    'M15.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zM5 12c-2.8 0-5 2.2-5 5s2.2 5 5 5 5-2.2 5-5-2.2-5-5-5zm0 8.5c-1.9 0-3.5-1.6-3.5-3.5s1.6-3.5 3.5-3.5 3.5 1.6 3.5 3.5-1.6 3.5-3.5 3.5zm5.8-10l2.4-2.4.8.8c1.3 1.3 3 2.1 5.1 2.1V9c-1.5 0-2.7-.6-3.6-1.5l-1.9-1.9c-.5-.4-1-.6-1.6-.6s-1.1.2-1.4.6L7.8 8.4C7.4 8.8 7 9.5 7 10c0 .6.2 1.2.8 1.6l3.1 2.1v2.8h2v-4l-2.1-1.5zm3.7 1.5c-2.8 0-5 2.2-5 5s2.2 5 5 5 5-2.2 5-5-2.2-5-5-5zm0 8.5c-1.9 0-3.5-1.6-3.5-3.5s1.6-3.5 3.5-3.5 3.5 1.6 3.5 3.5-1.6 3.5-3.5 3.5z',
  car:     'M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z',
  bus:     'M4 16c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4s-8 .5-8 4v10zm3.5 1c-.83 0-1.5-.67-1.5-1.5S6.67 14 7.5 14s1.5.67 1.5 1.5S8.33 17 7.5 17zm9 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm1.5-6H6V6h12v5z',
  shuttle: 'M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z',
  taxi:    'M18.92 6.01C18.72 5.42 18.16 5 17.5 5H16V4c0-.55-.45-1-1-1H9c-.55 0-1 .45-1 1v1H6.5c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z',
}

const sections = [
  {
    key: 'general',
    icon: 'general',
    nl: {
      title: 'Algemeen & Contact',
      type: 'text',
      content: `Het U Festival is voor (nieuwe) studenten in de regio Utrecht en is een aanvulling op UIT.\n\nLocatie: Strijkviertel, Utrecht\nNavigatieadres: Strijkviertelweg, Utrecht\n\nDag 1: Zaterdag 5 september 2026 — 12:00 tot 23:30 uur\nDag 2: Zondag 6 september 2026 — 12:00 tot 23:30 uur`
    },
    en: {
      title: 'General & Contact',
      type: 'text',
      content: `The U Festival is for (new) students in the Utrecht area and is a complement to UIT.\n\nLocation: Strijkviertel, Utrecht\nNavigation address: Strijkviertelweg, Utrecht\n\nDay 1: Saturday 5 September 2026 — 12:00 to 23:30\nDay 2: Sunday 6 September 2026 — 12:00 to 23:30`
    }
  },
  {
    key: 'transport',
    icon: 'transport',
    nl: {
      title: 'Bereikbaarheid',
      type: 'transport',
      items: [
        { icon: 'bike',    title: 'Fiets',             text: 'Er is een grote gratis fietsenstalling aanwezig waar je jouw fiets de gehele dag kunt stallen.' },
        { icon: 'car',     title: 'Auto',              text: 'Parkeren op P+R Papendorp, volg de borden "P online ticket". Let op: VOL = VOL (PIN ONLY).' },
        { icon: 'bus',     title: 'Openbaar Vervoer',  text: 'Plan je trip via 9292.nl' },
        { icon: 'shuttle', title: 'Shuttlebus',        text: 'Gratis shuttlebus vanaf Utrecht Centraal (Mineurslaan). Rijdt 12:00–19:00 heen, vanaf 21:00 terug.' },
        { icon: 'taxi',    title: 'Taxi + Kiss & Ride', text: 'Navigeer naar Strijkviertel, De Meern (Utrecht). Volg de borden "Kiss & Ride U Festival".' },
      ]
    },
    en: {
      title: 'Getting Here',
      type: 'transport',
      items: [
        { icon: 'bike',    title: 'Bicycle',           text: 'A large free bicycle parking is available where you can leave your bike for the entire day.' },
        { icon: 'car',     title: 'Car',               text: 'Park at P+R Papendorp, follow signs for "P online ticket". Note: FULL = FULL (PIN ONLY).' },
        { icon: 'bus',     title: 'Public Transport',  text: 'Plan your trip via 9292.nl' },
        { icon: 'shuttle', title: 'Shuttle Bus',        text: 'Free shuttle bus from Utrecht Central Station (Mineurslaan). Runs 12:00–19:00 to festival, from 21:00 back.' },
        { icon: 'taxi',    title: 'Taxi + Kiss & Ride', text: 'Navigate to Strijkviertel, De Meern (Utrecht). Follow the signs "Kiss & Ride U Festival".' },
      ]
    }
  },
  {
    key: 'lockers',
    icon: 'lockers',
    nl: {
      title: 'Kluisjes',
      type: 'text',
      content: `Op het festivalterrein zijn kluisjes aanwezig waar je je spullen veilig kunt opbergen!\n\nHier passen 3 à 4 jassen in. Je kunt je kluisje de gehele dag openen en sluiten zo vaak je wilt.\n\nHet is niet mogelijk om online een kluisje te reserveren.`
    },
    en: {
      title: 'Lockers',
      type: 'text',
      content: `Lockers are available on the festival grounds where you can safely store your belongings!\n\nThey can fit 3 to 4 jackets. You can open and close your locker as many times as you like throughout the day.\n\nIt is not possible to reserve a locker online.`
    }
  },
  {
    key: 'faq',
    icon: 'faq',
    nl: {
      title: 'FAQ',
      type: 'faq',
      items: [
        {
          q: 'Ik gebruik medicatie. Wat nu?',
          a: 'Het is toegestaan om medicijnen mee te nemen in een dosis die je maximaal nodig hebt op 1 dag. Een doktersverklaring/medicatiepaspoort is noodzakelijk.'
        },
        {
          q: 'Mag ik het festivalterrein tussentijds verlaten?',
          a: 'Nee, helaas is dat niet mogelijk. Om de veiligheid van alle bezoekers te kunnen waarborgen, kunnen we het niet toestaan dat het festivalterrein tussentijds verlaten wordt.'
        }
      ]
    },
    en: {
      title: 'FAQ',
      type: 'faq',
      items: [
        {
          q: 'I use medication. What now?',
          a: 'You are allowed to bring medication in a dose that you need for 1 day. A doctor\'s certificate/medication passport is required.'
        },
        {
          q: 'Can I leave the festival grounds during the event?',
          a: 'No, unfortunately that is not possible. To ensure the safety of all visitors, we cannot allow the festival grounds to be left during the event.'
        }
      ]
    }
  },
  {
    key: 'golden',
    icon: 'golden',
    nl: {
      title: 'Golden-GLU',
      type: 'text',
      content: `Studenten van het GLU hebben tijdens het festival speciale privileges en zijn herkenbaar aan een gouden armbandje.\n\nMet dit gouden armbandje kunnen ze tijdens het festival gebruik maken van de gouden toiletten en met goud gemarkeerde bestelpunten aan de bars zonder in een rij te hoeven staan.`
    },
    en: {
      title: 'Golden-GLU',
      type: 'text',
      content: `GLU students have special privileges during the festival and are recognizable by a golden wristband.\n\nWith this golden wristband they can use the golden toilets and gold-marked order points at the bars without having to queue.`
    }
  }
]

function toggle(key) {
  open.value = open.value === key ? null : key
}

function activeSection(section) {
  return locale.value === 'nl' ? section.nl : section.en
}
</script>

<template>
  <div class="page">
    <h1 class="page-title">{{ locale === 'nl' ? 'Festival Info' : 'Festival Info' }}</h1>

    <div class="accordion">
      <div v-for="section in sections" :key="section.key" class="accordion-item">
        <button
          class="accordion-header"
          :class="{ 'accordion-header--open': open === section.key }"
          @click="toggle(section.key)"
        >
          <!-- Custom SVG icoon per sectie -->
          <svg class="accordion-icon" viewBox="0 0 24 24" fill="currentColor" width="22" height="22">
            <path :d="ICONS[section.icon]"/>
          </svg>
          <span>{{ activeSection(section).title }}</span>
          <!-- Chevron icoon (omhoog/omlaag) -->
          <svg class="accordion-chevron" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
            <path v-if="open === section.key" d="M12 8l-6 6 1.41 1.41L12 10.83l4.59 4.58L18 14z"/>
            <path v-else d="M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6z"/>
          </svg>
        </button>

        <Transition name="accordion-slide">
          <div v-if="open === section.key" class="accordion-body">

            <!-- Gewone tekst -->
            <template v-if="activeSection(section).type === 'text'">
              <p
                v-for="(line, i) in activeSection(section).content.split('\n')"
                :key="i"
                :class="line === '' ? 'spacer' : 'line'"
              >{{ line }}</p>
            </template>

            <!-- Transport-lijst met iconen -->
            <template v-else-if="activeSection(section).type === 'transport'">
              <div
                v-for="item in activeSection(section).items"
                :key="item.icon"
                class="transport-item"
              >
                <div class="transport-icon">
                  <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                    <path :d="TRANSPORT_ICONS[item.icon]"/>
                  </svg>
                </div>
                <div class="transport-text">
                  <div class="transport-title">{{ item.title }}</div>
                  <div class="transport-desc">{{ item.text }}</div>
                </div>
              </div>
            </template>

            <!-- FAQ-lijst met vraagteken-icoon -->
            <template v-else-if="activeSection(section).type === 'faq'">
              <div
                v-for="(item, i) in activeSection(section).items"
                :key="i"
                class="faq-item"
              >
                <div class="faq-q-row">
                  <svg class="faq-icon" viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                    <path d="M11 18h2v-2h-2v2zm1-16C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-14c-2.21 0-4 1.79-4 4h2c0-1.1.9-2 2-2s2 .9 2 2c0 2-3 1.75-3 5h2c0-2.25 3-2.5 3-5 0-2.21-1.79-4-4-4z"/>
                  </svg>
                  <span class="faq-q">{{ item.q }}</span>
                </div>
                <p class="faq-a">{{ item.a }}</p>
              </div>
            </template>

          </div>
        </Transition>
      </div>
    </div>
  </div>
</template>

<style scoped>
.accordion {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.accordion-item {
  border-radius: var(--radius);
  overflow: hidden;
  border: 1px solid var(--color-border);
}

.accordion-header {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.9rem 1rem;
  background: var(--color-surface);
  border: none;
  text-align: left;
  font-size: 0.95rem;
  font-weight: 700;
  color: var(--color-text);
  transition: background var(--transition);
  cursor: pointer;
}

.accordion-header--open {
  background: var(--color-secondary);
  color: #fff;
  font-style: italic;
}
.accordion-header--open .accordion-icon { color: #fff; }

.accordion-icon { color: var(--color-secondary); flex-shrink: 0; }
.accordion-header--open .accordion-icon { color: #fff; }

.accordion-chevron { margin-left: auto; flex-shrink: 0; }

.accordion-body {
  padding: 1rem;
  background: var(--color-bg);
  font-size: 0.88rem;
  line-height: 1.6;
  border-top: 1px solid var(--color-border);
}

/* Tekst-secties */
.line { margin-bottom: 0.2rem; }
.spacer { height: 0.6rem; }

/* Transport-lijst */
.transport-item {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
  padding: 0.55rem 0;
  border-bottom: 1px solid var(--color-border);
}
.transport-item:last-child { border-bottom: none; }
.transport-icon {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  background: var(--color-secondary);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-top: 2px;
}
.transport-title { font-weight: 700; color: var(--color-text); margin-bottom: 0.15rem; }
.transport-desc  { color: var(--color-text-muted); font-size: 0.83rem; line-height: 1.45; }

/* FAQ-lijst */
.faq-item {
  padding: 0.6rem 0;
  border-bottom: 1px solid var(--color-border);
}
.faq-item:last-child { border-bottom: none; }
.faq-q-row {
  display: flex;
  align-items: flex-start;
  gap: 0.5rem;
  margin-bottom: 0.4rem;
}
.faq-icon { color: var(--color-accent); flex-shrink: 0; margin-top: 1px; }
.faq-q { font-weight: 700; color: var(--color-text); font-size: 0.88rem; }
.faq-a { color: var(--color-text-muted); font-size: 0.84rem; line-height: 1.5; padding-left: 1.6rem; }

/* Animatie */
.accordion-slide-enter-active,
.accordion-slide-leave-active {
  transition: all 0.25s ease;
  overflow: hidden;
  max-height: 800px;
}
.accordion-slide-enter-from,
.accordion-slide-leave-to {
  max-height: 0;
  opacity: 0;
}
</style>
