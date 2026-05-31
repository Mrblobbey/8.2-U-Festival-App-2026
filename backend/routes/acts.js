const express = require('express')
const router = express.Router()
const db = require('../db/connection')

router.get('/', async (req, res) => {
  const [rows] = await db.query('SELECT * FROM acts ORDER BY name')
  res.json(rows)
})

router.get('/:id', async (req, res) => {
  const [rows] = await db.query('SELECT * FROM acts WHERE id = ?', [req.params.id])
  if (!rows.length) return res.status(404).json({ error: 'Act not found' })
  res.json(rows[0])
})

module.exports = router
