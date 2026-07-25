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

app.get('/api/migrate-cdf', async (req, res) => {
  try {
    await pool.query(`
      ALTER TABLE soins ADD COLUMN IF NOT EXISTS prix_salon_cdf DECIMAL(12,2);
      ALTER TABLE soins ADD COLUMN IF NOT EXISTS prix_domicile_cdf DECIMAL(12,2);
      ALTER TABLE reservations_salon ADD COLUMN IF NOT EXISTS devise VARCHAR(3) DEFAULT 'USD';
      ALTER TABLE reservations_domicile ADD COLUMN IF NOT EXISTS devise VARCHAR(3) DEFAULT 'USD';
      ALTER TABLE locations_coiffeuse ADD COLUMN IF NOT EXISTS devise VARCHAR(3) DEFAULT 'USD';
    `);
    res.json({ message: 'Colonnes CDF ajoutées' });
  } catch (err) {
    res.status(500).json({ message: err.message });
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
    const { rows } = await pool.query('SELECT COUNT(*) FROM salons');
	if (parseInt(rows[0].count) === 0) {
  	await runSeeds();
  	console.log('Seeds exécutés');
	} else {
  	console.log('Base déjà peuplée, seeds ignorés');
	}
    console.log('Base de données prête');
  });
}

app.get('/api/cleanup', async (req, res) => {
  try {
    await pool.query('DELETE FROM soins a USING soins b WHERE a.nom = b.nom AND a.ctid > b.ctid');
    await pool.query('DELETE FROM types_soins a USING types_soins b WHERE a.nom = b.nom AND a.ctid > b.ctid');
    await pool.query('DELETE FROM gammes a USING gammes b WHERE a.nom = b.nom AND a.ctid > b.ctid');
    await pool.query('DELETE FROM coiffeuses a USING coiffeuses b WHERE a.utilisateur_id = b.utilisateur_id AND a.ctid > b.ctid');
    await pool.query('DELETE FROM utilisateurs a USING utilisateurs b WHERE a.email = b.email AND a.ctid > b.ctid');
    await pool.query('DELETE FROM salons a USING salons b WHERE a.nom = b.nom AND a.ctid > b.ctid');
    res.json({ message: 'Doublons supprimés' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.get('/api/reseed', async (req, res) => {
  try {
    await pool.query('DELETE FROM specialites_coiffeuses');
    await pool.query('DELETE FROM reservations_salon');
    await pool.query('DELETE FROM reservations_domicile');
    await pool.query('DELETE FROM locations_coiffeuse');
    await pool.query('DELETE FROM coiffeuses');
    await pool.query('DELETE FROM utilisateurs');
    await pool.query('DELETE FROM soins');
    await pool.query('DELETE FROM types_soins');
    await pool.query('DELETE FROM gammes');
    await pool.query('DELETE FROM salons');

    await pool.query(`INSERT INTO salons (nom, adresse, ville, telephone) VALUES
      ('Afrosa Gombe', 'Avenue du Commerce, Gombe', 'Kinshasa', '+243810001234'),
      ('Afrosa Kinshasa', 'Boulevard du 30 Juin, Kinshasa', 'Kinshasa', '+243810005678'),
      ('Afrosa Ngaliema', 'Avenue Victoire, Ngaliema', 'Kinshasa', '+243810009012')`);

await pool.query(`INSERT INTO horaires_salon (salon_id, jour, heure_ouverture, heure_fermeture)
  SELECT id, 'lundi', '09:00', '19:00' FROM salons`);
await pool.query(`INSERT INTO horaires_salon (salon_id, jour, heure_ouverture, heure_fermeture)
  SELECT id, 'mardi', '09:00', '19:00' FROM salons`);
await pool.query(`INSERT INTO horaires_salon (salon_id, jour, heure_ouverture, heure_fermeture)
  SELECT id, 'mercredi', '09:00', '19:00' FROM salons`);
await pool.query(`INSERT INTO horaires_salon (salon_id, jour, heure_ouverture, heure_fermeture)
  SELECT id, 'jeudi', '09:00', '19:00' FROM salons`);
await pool.query(`INSERT INTO horaires_salon (salon_id, jour, heure_ouverture, heure_fermeture)
  SELECT id, 'vendredi', '09:00', '19:00' FROM salons`);
await pool.query(`INSERT INTO horaires_salon (salon_id, jour, heure_ouverture, heure_fermeture)
  SELECT id, 'samedi', '08:00', '18:00' FROM salons`);

    const salons = await pool.query('SELECT id, nom FROM salons ORDER BY nom');
    const salonGombe = salons.rows.find(s => s.nom === 'Afrosa Gombe')?.id;
    const salonKinshasa = salons.rows.find(s => s.nom === 'Afrosa Kinshasa')?.id;
    const salonNgaliema = salons.rows.find(s => s.nom === 'Afrosa Ngaliema')?.id;

    await pool.query(`INSERT INTO gammes (nom, description) VALUES
      ('Signature', 'Notre gamme premium de soins sur mesure'),
      ('Naturelle', 'Soins doux aux ingrédients naturels'),
      ('Événement', 'Coiffures élaborées pour vos occasions spéciales')`);

    await pool.query(`INSERT INTO types_soins (gamme_id, nom)
      SELECT id, 'Tresses & Braids' FROM gammes WHERE nom = 'Signature'`);
    await pool.query(`INSERT INTO types_soins (gamme_id, nom)
      SELECT id, 'Soins & Traitements' FROM gammes WHERE nom = 'Naturelle'`);
    await pool.query(`INSERT INTO types_soins (gamme_id, nom)
      SELECT id, 'Tissage & Perruques' FROM gammes WHERE nom = 'Signature'`);
    await pool.query(`INSERT INTO types_soins (gamme_id, nom)
      SELECT id, 'Coiffures Événement' FROM gammes WHERE nom = 'Événement'`);

    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Box braids mi-longues', 'Tresses protectrices mi-longues', 240, 40.00, 88000.00, 55.00, 121000.00 FROM types_soins WHERE nom = 'Tresses & Braids'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Box braids longues', 'Tresses protectrices longues', 360, 60.00, 132000.00, 80.00, 176000.00 FROM types_soins WHERE nom = 'Tresses & Braids'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Vanilles / Twists', 'Twists naturels et élégants', 180, 30.00, 66000.00, 40.00, 88000.00 FROM types_soins WHERE nom = 'Tresses & Braids'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Shampoing + Brushing', 'Lavage et mise en forme', 45, 10.00, 22000.00, 15.00, 33000.00 FROM types_soins WHERE nom = 'Soins & Traitements'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Soin hydratant profond', 'Masque nourrissant et restructurant', 60, 12.00, 26400.00, 18.00, 39600.00 FROM types_soins WHERE nom = 'Soins & Traitements'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Défrisage', 'Lissage chimique professionnel', 90, 18.00, 39600.00, 25.00, 55000.00 FROM types_soins WHERE nom = 'Soins & Traitements'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Tissage mi-long', 'Pose de tissage naturel', 120, 28.00, 61600.00, 38.00, 83600.00 FROM types_soins WHERE nom = 'Tissage & Perruques'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Pose de perruque', 'Installation et coiffage perruque', 90, 22.00, 48400.00, 30.00, 66000.00 FROM types_soins WHERE nom = 'Tissage & Perruques'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Coiffure mariage', 'Coiffure élaborée pour mariée', 180, 80.00, 176000.00, 100.00, 220000.00 FROM types_soins WHERE nom = 'Coiffures Événement'`);
    await pool.query(`INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
      SELECT id, 'Coiffure soirée', 'Mise en beauté pour soirée', 90, 30.00, 66000.00, 40.00, 88000.00 FROM types_soins WHERE nom = 'Coiffures Événement'`);

    await pool.query(`INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, telephone, role) VALUES
      ('Diallo', 'Aminata', 'aminata@afrosa.cd', '$2b$10$placeholder_hash', '+243810000001', 'coiffeuse'),
      ('Mbaye', 'Fatou', 'fatou@afrosa.cd', '$2b$10$placeholder_hash', '+243810000002', 'coiffeuse'),
      ('Kouassi', 'Binta', 'binta@afrosa.cd', '$2b$10$placeholder_hash', '+243810000003', 'coiffeuse'),
      ('Admin', 'Afrosa', 'admin@afrosa.cd', '$2b$10$placeholder_hash', '+243810000000', 'admin')`);

    await pool.query(`INSERT INTO coiffeuses (utilisateur_id, salon_id, bio, disponible_domicile, disponible_location, tarif_journee)
      SELECT u.id, $1, 'Spécialiste tresses et soins naturels, 5 ans d''expérience.', true, true, 50.00
      FROM utilisateurs u WHERE u.email = 'aminata@afrosa.cd'`, [salonGombe]);
    await pool.query(`INSERT INTO coiffeuses (utilisateur_id, salon_id, bio, disponible_domicile, disponible_location, tarif_journee)
      SELECT u.id, $1, 'Experte tissage et perruques, coiffures de mariée.', true, true, 60.00
      FROM utilisateurs u WHERE u.email = 'fatou@afrosa.cd'`, [salonKinshasa]);
    await pool.query(`INSERT INTO coiffeuses (utilisateur_id, salon_id, bio, disponible_domicile, disponible_location, tarif_journee)
      SELECT u.id, $1, 'Passionnée de locks et coiffures naturelles.', false, true, 45.00
      FROM utilisateurs u WHERE u.email = 'binta@afrosa.cd'`, [salonNgaliema]);

    res.json({ message: 'Base recréée avec succès', salons: { gombe: salonGombe, kinshasa: salonKinshasa, ngaliema: salonNgaliema } });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});
module.exports = app;