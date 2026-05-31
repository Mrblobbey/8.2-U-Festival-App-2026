const express = require('express')
const router = express.Router()
const db = require('../db/connection')

router.get('/', async (req, res) => {
  const [rows] = await db.query('SELECT * FROM stages ORDER BY id')
  res.json(rows)
})

module.exports = router
