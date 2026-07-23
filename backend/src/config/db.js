const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_URL && process.env.DATABASE_URL.includes('railway') 
    ? { rejectUnauthorized: false } 
    : false,
});

pool.connect()
  .then(() => console.log('PostgreSQL connecté'))
  .catch(err => console.error('Erreur de connexion PostgreSQL :', err.message));

module.exports = pool;