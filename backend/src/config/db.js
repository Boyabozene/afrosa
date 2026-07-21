const { Pool } = require('pg');

const pool = new Pool({
  user: 'afrosa_user',
  host: 'db',
  port: 5432,
  database: 'afrosa',
  password: 'afrosa123',
});

const connectWithRetry = async (retries = 10, delay = 3000) => {
  for (let i = 0; i < retries; i++) {
    try {
      await pool.connect();
      console.log('PostgreSQL connecté');
      return;
    } catch (err) {
      console.log(`Tentative ${i + 1}/${retries} échouée. Retry dans ${delay/1000}s...`);
      await new Promise(res => setTimeout(res, delay));
    }
  }
  console.error('Impossible de se connecter à PostgreSQL');
};

connectWithRetry();

module.exports = pool;