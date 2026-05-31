const express = require('express')
const cors = require('cors')
require('dotenv').config()

const app = express()
app.use(cors())
app.use(express.json())

app.use('/api/acts', require('./routes/acts'))
app.use('/api/stages', require('./routes/stages'))
app.use('/api/schedule', require('./routes/schedule'))
app.use('/api/news', require('./routes/news'))

app.get('/api/health', (req, res) => res.json({ status: 'ok' }))

const PORT = process.env.PORT || 3000
app.listen(PORT, () => console.log(`Backend draait op http://localhost:${PORT}`))
