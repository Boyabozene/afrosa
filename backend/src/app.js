require('dotenv').config();
const express = require('express');
const cors = require('cors');
const pool = require('./config/db');

const authRoutes = require('./routes/authRoutes');

const app = express();
const { verifierToken } = require('./middlewares/authMiddleware');
const { verifierRole } = require('./middlewares/roleMiddleware');

const salonRoutes = require('./routes/salonRoutes');
const soinRoutes = require('./routes/soinRoutes');
const coiffeuseRoutes = require('./routes/coiffeuseRoutes');
const reservationSalonRoutes = require('./routes/reservationSalonRoutes');
const reservationDomicileRoutes = require('./routes/reservationDomicileRoutes');
const locationRoutes = require('./routes/locationRoutes');

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

if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Afrosa API démarrée sur le port ${PORT}`);
  });
}

module.exports = app;

module.exports = app;