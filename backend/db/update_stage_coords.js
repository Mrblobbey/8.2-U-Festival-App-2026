const mysql = require('mysql2/promise')
const path = require('path')
require('dotenv').config({ path: path.join(__dirname, '../.env') })

// Gecorrigeerde coördinaten — SVG content-hoogte is 1203.5 (niet 1353.19)
const coords = [
  { name: 'Ponton',    lat: 52.072567, lng: 5.083665 },
  { name: 'The Lake',  lat: 52.073557, lng: 5.087742 },
  { name: 'The Club',  lat: 52.073635, lng: 5.089658 },
  { name: 'Hangar',   lat: 52.074623, lng: 5.092275 },
]

async function run() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'ufestival',
  })
  for (const s of coords) {
    const [result] = await conn.execute(
      'UPDATE stages SET lat = ?, lng = ? WHERE name = ?',
      [s.lat, s.lng, s.name]
    )
    console.log(`${s.name}: ${result.affectedRows} row(s) updated`)
  }
  await conn.end()
  console.log('Done.')
}

run().catch(console.error)
