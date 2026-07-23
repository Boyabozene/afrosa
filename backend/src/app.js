require('dotenv').config();
const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const pool = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const salonRoutes = require('./routes/salonRoutes');
const soinRoutes = require('./routes/soinRoutes');
const coiffeuseRoutes = require('./routes/coiffeuseRoutes');
const reservationSalonRoutes = require('./routes/reservationSalonRoutes');
const reservationDomicileRoutes = require('./routes/reservationDomicileRoutes');
const locationRoutes = require('./routes/locationRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Afrosa API en ligne', version: '1.0.0' });
});

app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT NOW()');
    res.json({ status: 'ok', database: 'connectée' });
  } catch (err) {
    res.status(500).json({ status: 'erreur', database: err.message });
  }
});

app.use('/api/auth', authRoutes);
app.use('/api/salons', salonRoutes);
app.use('/api/soins', soinRoutes);
app.use('/api/coiffeuses', coiffeuseRoutes);
app.use('/api/reservations/salon', reservationSalonRoutes);
app.use('/api/reservations/domicile', reservationDomicileRoutes);
app.use('/api/locations', locationRoutes);

const runMigrations = async () => {
  const migrationsPath = path.join(__dirname, '../database/migrations');
  if (!fs.existsSync(migrationsPath)) return;
  const files = fs.readdirSync(migrationsPath).sort();
  for (const file of files) {
    const sql = fs.readFileSync(path.join(migrationsPath, file), 'utf8');
    try {
      await pool.query(sql);
      console.log(`Migration OK: ${file}`);
    } catch (err) {
      if (!err.message.includes('already exists')) {
        console.error(`Migration erreur ${file}:`, err.message);
      }
    }
  }
};

const runSeeds = async () => {
  const seedsPath = path.join(__dirname, '../database/seeds');
  if (!fs.existsSync(seedsPath)) return;
  const files = fs.readdirSync(seedsPath).sort();
  for (const file of files) {
    const sql = fs.readFileSync(path.join(seedsPath, file), 'utf8');
    try {
      await pool.query(sql);
      console.log(`Seed OK: ${file}`);
    } catch (err) {
      if (!err.message.includes('already exists') && !err.message.includes('duplicate')) {
        console.error(`Seed erreur ${file}:`, err.message);
      }
    }
  }
};

if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, async () => {
    console.log(`Afrosa API démarrée sur le port ${PORT}`);
    await runMigrations();
    await runSeeds();
    console.log('Base de données prête');
  });
}

module.exports = app;