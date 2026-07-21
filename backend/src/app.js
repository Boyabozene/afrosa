require('dotenv').config();
const express = require('express');
const cors = require('cors');
const db = require('./config/db');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Afrosa API en ligne', version: '1.0.0' });
});

app.get('/health', async (req, res) => {
  try {
    await db.query('SELECT NOW()');
    res.json({ status: 'ok', database: 'connectée' });
  } catch (err) {
    res.status(500).json({ status: 'erreur', database: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Afrosa API démarrée sur le port ${PORT}`);
});

module.exports = app;
