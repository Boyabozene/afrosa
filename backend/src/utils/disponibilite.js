const pool = require('../config/db');

const getCreneauxDisponibles = async (coiffeuseId, soinId, date) => {
  const soin = await pool.query('SELECT duree_minutes FROM soins WHERE id = $1', [soinId]);
  if (soin.rows.length === 0) throw new Error('Soin non trouvé');
  const duree = soin.rows[0].duree_minutes;

  const coiffeuse = await pool.query(
    'SELECT c.*, s.id as salon_id FROM coiffeuses c JOIN salons s ON s.id = c.salon_id WHERE c.id = $1',
    [coiffeuseId]
  );
  if (coiffeuse.rows.length === 0) throw new Error('Coiffeuse non trouvée');

  const jours = ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'];
  const dateObj = new Date(date);
  const jourSemaine = jours[dateObj.getDay()];

  const horaire = await pool.query(
    'SELECT * FROM horaires_salon WHERE salon_id = $1 AND jour = $2',
    [coiffeuse.rows[0].salon_id, jourSemaine]
  );

  if (horaire.rows.length === 0) return [];

  const ouverture = horaire.rows[0].heure_ouverture;
  const fermeture = horaire.rows[0].heure_fermeture;

  const rdvExistants = await pool.query(`
    SELECT rs.date_heure, s.duree_minutes
    FROM reservations_salon rs
    JOIN soins s ON s.id = rs.soin_id
    WHERE rs.coiffeuse_id = $1
    AND DATE(rs.date_heure) = $2
    AND rs.statut = 'confirmee'
  `, [coiffeuseId, date]);

  const [hOuv, mOuv] = ouverture.split(':').map(Number);
  const [hFerm, mFerm] = fermeture.split(':').map(Number);

  const debut = hOuv * 60 + mOuv;
  const fin = hFerm * 60 + mFerm;

  const occupes = rdvExistants.rows.map(rdv => {
    const d = new Date(rdv.date_heure);
    const startMin = d.getHours() * 60 + d.getMinutes();
    return { debut: startMin, fin: startMin + rdv.duree_minutes };
  });

  const creneaux = [];
  for (let m = debut; m + duree <= fin; m += 30) {
    const chevauchement = occupes.some(o => m < o.fin && m + duree > o.debut);
    if (!chevauchement) {
      const h = Math.floor(m / 60).toString().padStart(2, '0');
      const min = (m % 60).toString().padStart(2, '0');
      creneaux.push(`${h}:${min}`);
    }
  }

  return creneaux;
};

module.exports = { getCreneauxDisponibles };