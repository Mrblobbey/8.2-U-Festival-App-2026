# Prompt Logboek — U-Festival App 2026

**Project:** U-Festival App 2026  
**Student:** Rody Stockschen  
**Stack:** Vue 3 + Vite (frontend) · Node.js + Express (backend) · SQLite (database)  
**Periode:** 24 april 2026 – 5 juni 2026

---

## Week 1 — Projectopzet (24 april – 30 april)

### 24 april 2026
**Prompt:**  
> Geef mij een handleiding voor het opzetten van een nieuw Vue 3-project met Vite. Leg uit wat Vite is en waarom het sneller is dan de oude Vue CLI.

**Samenvatting:**  
Uitleg over het installeren van Node.js en het aanmaken van een Vite-project via `npm create vite@latest`. Toelichting op de mappenstructuur (`src/`, `public/`, `main.js`) en wat elk bestand doet.

---

### 25 april 2026
**Prompt:**  
> Schrijf een handleiding voor het opzetten van een Node.js + Express backend. Hoe maak ik een `server.js` aan en hoe start ik de server?

**Samenvatting:**  
Stap-voor-stap uitleg over het installeren van Express via npm, het aanmaken van `server.js`, het definiëren van een basis-route (`GET /`) en het starten met `node server.js`. Uitleg over wat een server doet en wat een request en response zijn.

---

### 26 april 2026
**Prompt:**  
> Handleiding: hoe installeer ik SQLite in mijn Node.js project en hoe maak ik een database bestand aan?

**Samenvatting:**  
Uitleg over het installeren van `better-sqlite3`, het aanmaken van een `.db` bestand, en het uitvoeren van een eerste SQL-query om een tabel te maken. Toelichting op wat SQLite is en waarom het geschikt is voor kleine projecten.

---

### 28 april 2026
**Prompt:**  
> Geef mij een handleiding voor het instellen van Vue Router in Vue 3. Hoe maak ik meerdere pagina's aan zoals een homepage, infopagina en een programmapagina?

**Samenvatting:**  
Uitleg over het installeren van `vue-router`, het aanmaken van een `router/index.js` bestand, en het definiëren van routes voor `HomeView.vue`, `InfoView.vue`, `ScheduleView.vue` en `MapView.vue`. Toelichting op `<RouterView>` en `<RouterLink>`.

---

### 30 april 2026
**Prompt:**  
> Handleiding: hoe gebruik ik `jsconfig.json` in een Vue + Vite project om betere autocomplete te krijgen in mijn editor?

**Samenvatting:**  
Uitleg over het instellen van `jsconfig.json` met `baseUrl` en `paths` zodat imports zoals `@/components/...` werken. Toelichting op wat path aliases zijn en hoe je ze configureert in `vite.config.js`.

---

## Week 2 — Frontend Bouwen (1 mei – 7 mei)

### 1 mei 2026
**Prompt:**  
> Schrijf een handleiding voor het maken van een navigatiebalk als Vue-component. Hoe zorg ik dat de actieve pagina gemarkeerd is?

**Samenvatting:**  
Uitleg over het aanmaken van een `NavBar.vue` component in `src/components/`. Gebruik van `RouterLink` met de `active-class` prop en CSS om de actieve link te stijlen.

---

### 2 mei 2026
**Prompt:**  
> Handleiding: hoe laad ik afbeeldingen en andere assets (logo, foto's) in een Vue 3 project? Waar zet ik ze neer?

**Samenvatting:**  
Uitleg over het verschil tussen de `public/` map (statische bestanden, direct toegankelijk via URL) en de `src/assets/` map (verwerkt door Vite). Toelichting op het importeren van afbeeldingen in een Vue-component.

---

### 5 mei 2026
**Prompt:**  
> Geef mij een handleiding voor het gebruik van Pinia in Vue 3. Wat is een store en hoe gebruik ik die in mijn componenten?

**Samenvatting:**  
Uitleg over het installeren van Pinia, het aanmaken van een store met `defineStore()`, en het gebruiken van `state`, `getters` en `actions`. Concreet voorbeeld: een store voor festivalacts die acts ophaalt via een API-call.

---

### 6 mei 2026
**Prompt:**  
> Handleiding: hoe haal ik data op van mijn eigen backend API in Vue? Leg `fetch` uit en hoe verwerk ik de JSON-response.

**Samenvatting:**  
Stap-voor-stap uitleg over het gebruik van `fetch()` in een `onMounted()` lifecycle hook. Toelichting op `async/await`, foutafhandeling met `try/catch`, en het opslaan van de response in een `ref()`.

---

### 7 mei 2026
**Prompt:**  
> Schrijf een handleiding voor het aanmaken van Express routes in aparte bestanden. Hoe splits ik `acts.js`, `news.js`, `schedule.js` en `stages.js` op als losse route-bestanden?

**Samenvatting:**  
Uitleg over `express.Router()`, het aanmaken van losse route-bestanden per onderwerp, en het importeren en koppelen van deze routes in `server.js` via `app.use('/api/acts', actsRouter)`.

---

## Week 3 — Data en Functionaliteit (8 mei – 20 mei)

### 8 mei 2026
**Prompt:**  
> Handleiding: hoe maak ik een database-tabel voor festivalacts in SQLite? Welke kolommen heb ik nodig en hoe voeg ik testdata in?

**Samenvatting:**  
SQL-handleiding voor het aanmaken van een `acts`-tabel met kolommen zoals `id`, `name`, `stage`, `start_time`, `end_time` en `genre`. Uitleg over `INSERT INTO` voor het toevoegen van voorbeelddata.

---

### 10 mei 2026
**Prompt:**  
> Geef mij een handleiding voor het bouwen van een programmapagina (ScheduleView). Hoe toon ik acts gesorteerd op tijd per podium?

**Samenvatting:**  
Uitleg over het ophalen van de acts via de backend-API, het groeperen van acts op podium met JavaScript (`reduce()`), en het renderen van de data in een Vue-template met `v-for`.

---

### 13 mei 2026
**Prompt:**  
> Handleiding: hoe stel ik CORS in op mijn Express backend zodat mijn Vue frontend er verbinding mee kan maken?

**Samenvatting:**  
Uitleg over het installeren van het `cors` npm-pakket, het configureren ervan in `server.js`, en waarom CORS-fouten ontstaan (origin-beleid van browsers). Toelichting op het instellen van toegestane origins.

---

### 15 mei 2026
**Prompt:**  
> Schrijf een handleiding voor het gebruik van `composables` in Vue 3. Wat zijn composables en wanneer gebruik ik ze?

**Samenvatting:**  
Uitleg over het hergebruiken van logica via composables (`use`-functies in `src/composables/`). Voorbeeld: een `useFetch.js` composable die data ophaalt van de API en `isLoading`, `data` en `error` teruggeeft.

---

### 17 mei 2026
**Prompt:**  
> Handleiding: hoe voeg ik een interactieve kaart toe aan mijn app (MapView)? Zijn er Vue-bibliotheken voor kaarten?

**Samenvatting:**  
Overzicht van kaartbibliotheken compatibel met Vue 3: Leaflet (via `vue-leaflet`) en Google Maps. Stap-voor-stap uitleg voor het integreren van Leaflet: installeren, een marker per podium plaatsen, en de kaart stylen.

---

### 20 mei 2026
**Prompt:**  
> Geef mij een handleiding voor het opzetten van de volledige projectstructuur met een `package.json` in de root die zowel frontend als backend kan starten.

**Samenvatting:**  
Uitleg over het aanmaken van een root-`package.json` met scripts `"frontend"`, `"backend"` en `"build"` via `npm run`. Toelichting op `concurrently` voor het parallel starten van beide servers.

---

## Week 4 — Afwerking en PWA (21 mei – 31 mei)

### 21 mei 2026
**Prompt:**  
> Handleiding: wat is een PWA (Progressive Web App) en hoe maak ik mijn Vue 3 app een PWA?

**Samenvatting:**  
Uitleg over wat een PWA is (installeerbaar, werkt offline, heeft een manifest). Stap-voor-stap handleiding voor het installeren van `vite-plugin-pwa`, het configureren van een `manifest.json` (naam, iconen, kleuren) en het inschakelen van een service worker.

---

### 23 mei 2026
**Prompt:**  
> Schrijf een handleiding voor het toevoegen van meertaligheid (i18n) aan een Vue 3 app. Hoe zorg ik dat de app zowel Nederlands als Engels ondersteunt?

**Samenvatting:**  
Uitleg over het installeren van `vue-i18n`, het aanmaken van taalbestanden (`nl.json`, `en.json`) in `src/i18n/`, en het gebruik van `$t('key')` in templates. Toelichting op het wisselen van taal via een knop.

---

### 26 mei 2026
**Prompt:**  
> Handleiding: hoe style ik mijn Vue-app met CSS? Leg uit hoe `scoped` CSS werkt in Vue-componenten.

**Samenvatting:**  
Uitleg over het verschil tussen globale CSS (in `main.css`) en scoped CSS (in `<style scoped>` binnen een component). Toelichting op CSS-variabelen voor kleuren en het gebruik van flexbox voor de layout.

---

### 28 mei 2026
**Prompt:**  
> Geef mij een handleiding voor het bouwen van mijn Vue-app voor productie. Wat doet `npm run build` en waar komen de bestanden terecht?

**Samenvatting:**  
Uitleg over het buildproces van Vite: bundelen, minificeren en optimaliseren. De gegenereerde bestanden komen in de `dist/` map. Toelichting op het verschil tussen development- en productiemodus en hoe je de build lokaal kunt testen met `vite preview`.

---

### 31 mei 2026
**Prompt:**  
> Handleiding: hoe test ik of mijn app goed werkt op een mobiel scherm? Wat zijn de belangrijkste punten voor responsive design?

**Samenvatting:**  
Uitleg over het gebruik van de developer tools in de browser (mobielemulatie). Aandachtspunten: viewport meta-tag, media queries, touch-vriendelijke knoppen (minimaal 44px), en leesbare tekst zonder zoomen. Praktische tips voor de festival-app zoals een hamburger-menu op kleine schermen.

---

## Week 5 — Afronden (1 juni – 5 juni)

### 2 juni 2026
**Prompt:**  
> Schrijf een handleiding voor het deployen van een Node.js + Vue app met Docker. Hoe maak ik een Dockerfile voor de backend?

**Samenvatting:**  
Stap-voor-stap uitleg over het schrijven van een `Dockerfile` voor de Node.js backend (basis-image, `COPY`, `RUN npm install`, `CMD`). Toelichting op het bouwen van een image met `docker build` en het starten van een container met `docker run`.

---

### 4 juni 2026
**Prompt:**  
> Handleiding: hoe voeg ik een `.gitignore` toe aan mijn project en welke bestanden moet ik uitsluiten van Git?

**Samenvatting:**  
Uitleg over het aanmaken van `.gitignore` met regels voor `node_modules/`, `.env`, `dist/`, en `*.db`. Toelichting op waarom je `node_modules` nooit in Git zet en hoe anderen het project daarna opnieuw kunnen installeren met `npm install`.

---

### 5 juni 2026
**Prompt:**  
> Geef mij een handleiding voor het schrijven van een goede README.md voor mijn festival-app. Wat hoort er minimaal in?

**Samenvatting:**  
Uitleg over de onderdelen van een goede README: projectbeschrijving, vereisten (Node.js versie, npm), installatie-instructies (`npm install`), hoe je de app start (frontend + backend), en een overzicht van de beschikbare pagina's. Optioneel: een screenshot van de app.

---

## Projectoverzicht

| Onderdeel         | Technologie              | Status  |
|-------------------|--------------------------|---------|
| Frontend          | Vue 3 + Vite             | Klaar   |
| Backend           | Node.js + Express        | Klaar   |
| Database          | SQLite (better-sqlite3)  | Klaar   |
| Routing           | Vue Router               | Klaar   |
| State management  | Pinia                    | Klaar   |
| Meertaligheid     | vue-i18n                 | Klaar   |
| PWA               | vite-plugin-pwa          | Klaar   |
| Kaart             | Leaflet / MapView        | Klaar   |
| Productie build   | Vite build → dist/       | Klaar   |
| Deployment        | Docker                   | Klaar   |

---

*Logboek aangemaakt op 5 juni 2026*
