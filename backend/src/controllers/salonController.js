const pool = require('../config/db');

const getTousSalons = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT s.*, 
        json_agg(json_build_object(
          'jour', h.jour,
          'ouverture', h.heure_ouverture,
          'fermeture', h.heure_fermeture
        )) as horaires
      FROM salons s
      LEFT JOIN horaires_salon h ON h.salon_id = s.id
      GROUP BY s.id
      ORDER BY s.nom
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getSalonById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(`
      SELECT s.*,
        json_agg(json_build_object(
          'jour', h.jour,
          'ouverture', h.heure_ouverture,
          'fermeture', h.heure_fermeture
        )) as horaires
      FROM salons s
      LEFT JOIN horaires_salon h ON h.salon_id = s.id
      WHERE s.id = $1
      GROUP BY s.id
    `, [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Salon non trouvé' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getCoiffeusesDuSalon = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(`
      SELECT c.*, u.nom, u.prenom, u.email, u.telephone,
        json_agg(json_build_object(
          'soin_id', sc.soin_id,
          'nom', s.nom
        )) as specialites
      FROM coiffeuses c
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      LEFT JOIN specialites_coiffeuses sc ON sc.coiffeuse_id = c.id
      LEFT JOIN soins s ON s.id = sc.soin_id
      WHERE c.salon_id = $1
      GROUP BY c.id, u.nom, u.prenom, u.email, u.telephone
    `, [id]);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { getTousSalons, getSalonById, getCoiffeusesDuSalon };