const express = require('express')
const router = express.Router()
const db = require('../db/connection')

router.get('/', async (req, res) => {
  const [rows] = await db.query(`
    SELECT
      s.id, s.start_time, s.end_time,
      a.id AS act_id, a.name AS act_name, a.genre, a.description_en, a.description_nl, a.youtube_url, a.image_url,
      st.id AS stage_id, st.name AS stage_name, st.color AS stage_color
    FROM schedule s
    JOIN acts a ON s.act_id = a.id
    JOIN stages st ON s.stage_id = st.id
    ORDER BY s.start_time, st.id
  `)
  res.json(rows)
})

module.exports = router
