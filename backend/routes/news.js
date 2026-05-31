const express = require('express')
const router = express.Router()
const db = require('../db/connection')

router.get('/', async (req, res) => {
  const [rows] = await db.query('SELECT * FROM news ORDER BY created_at DESC')
  res.json(rows)
})

module.exports = router
