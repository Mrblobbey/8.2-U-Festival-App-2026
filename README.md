# U-Festival App 2026

Schoolproject van Rody Stockschen — een festival-webapp voor het U-Festival op 5 september 2026.

## Stack

| Laag | Technologie |
|------|-------------|
| Frontend | Vue 3 + Vite, Pinia, vue-router, vue-i18n (NL/EN), Leaflet, PWA |
| Backend | Node.js + Express 5, mysql2, dotenv, cors |
| Database | MySQL — database `ufestival` |
| Testing | Vitest + @vue/test-utils |

## Projectstructuur

```
8.2-U-Festival-App-2026/
├── backend/
│   ├── server.js           # Express entrypoint, draait op port 3000
│   ├── routes/             # acts.js, stages.js, schedule.js, news.js
│   └── db/
│       ├── connection.js
│       ├── schema.sql      # tabellen + seed data
│       └── update_schedule.sql
├── frontend/
│   └── src/
│       ├── views/          # HomeView, InfoView, ScheduleView, MapView
│       ├── stores/app.js   # Pinia: darkMode + favorites (localStorage)
│       ├── router/index.js # 4 routes: /, /info, /schedule, /map
│       └── i18n/           # NL + EN vertalingen
├── assets/                 # Logo's, wireframes, screenshots
├── documenten/             # Logboek, planning, vragen, prompt-logboek
└── package.json
```

## Starten

```bash
# Backend (port 3000)
npm run backend

# Frontend (Vite dev server)
npm run frontend

# Of apart:
cd backend && node server.js
cd frontend && npm run dev
```

## API Endpoints

| Endpoint | Omschrijving |
|----------|-------------|
| `GET /api/acts` | Alle artiesten |
| `GET /api/stages` | Alle podia |
| `GET /api/schedule` | Festivalrooster |
| `GET /api/news` | Nieuwsberichten |
| `GET /api/health` | Health check |

## Festival (5 september 2026)

### Podia
| Podium | Kleur | Stijl |
|--------|-------|-------|
| Ponton | Rood | Main stage |
| The Lake | Blauw | Opkomend talent |
| The Club | Geel | Theater & comedy |
| Hangar | Zwart | House, techno & dance |

### Artiesten
| Artiest | Genre | Podium | Tijd |
|---------|-------|--------|------|
| Armin van Buuren | Trance | Ponton | 21:30 – 23:00 |
| Martin Garrix | EDM | Ponton | 19:00 – 20:30 |
| Kensington | Indie Rock | Ponton | 15:30 – 17:00 |
| Within Temptation | Symphonic Metal | Ponton | 13:00 – 14:30 |
| De Staat | Experimental Rock | The Lake | 18:30 – 20:00 |
| Navarone | Rock | The Lake | 16:00 – 17:30 |
| Dotan | Folk-Pop | The Lake | 13:30 – 15:00 |
| Chef'Special | Funk-Pop | The Club | 20:30 – 22:00 |
| Eefje de Visser | Indie-Pop | The Club | 16:30 – 17:30 |
| Froukje | Pop | The Club | 14:00 – 15:00 |
| Spinvis | Lo-fi / Indie | Hangar | 18:00 – 19:30 |

## App features

- Meertalig NL/EN (vue-i18n)
- Dark mode (opgeslagen in localStorage)
- Favorieten opslaan per artiest (localStorage)
- Interactieve festivalkaart (Leaflet)
- Programmaschema per podium
- Nieuwsfeed
- PWA — installeerbaar op telefoon/tablet
