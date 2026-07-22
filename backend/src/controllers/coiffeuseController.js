const pool = require('../config/db');
const { getCreneauxDisponibles } = require('../utils/disponibilite');

const getToutesCoiffeuses = async (req, res) => {
  try {
    const { soin_id } = req.query;
    let query = `
      SELECT c.*, u.nom, u.prenom, u.email, u.telephone, s.nom as salon_nom,
        json_agg(json_build_object('soin_id', sc.soin_id, 'nom', so.nom)) as specialites
      FROM coiffeuses c
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      JOIN salons s ON s.id = c.salon_id
      LEFT JOIN specialites_coiffeuses sc ON sc.coiffeuse_id = c.id
      LEFT JOIN soins so ON so.id = sc.soin_id
    `;
    const params = [];
    if (soin_id) {
      query += ` WHERE c.id IN (SELECT coiffeuse_id FROM specialites_coiffeuses WHERE soin_id = $1)`;
      params.push(soin_id);
    }
    query += ` GROUP BY c.id, u.nom, u.prenom, u.email, u.telephone, s.nom`;
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getCoiffeuseById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(`
      SELECT c.*, u.nom, u.prenom, u.email, u.telephone, s.nom as salon_nom
      FROM coiffeuses c
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      JOIN salons s ON s.id = c.salon_id
      WHERE c.id = $1
    `, [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Coiffeuse non trouvée' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getCreneaux = async (req, res) => {
  try {
    const { id } = req.params;
    const { soin_id, date } = req.query;
    if (!soin_id || !date) {
      return res.status(400).json({ message: 'soin_id et date requis' });
    }
    const creneaux = await getCreneauxDisponibles(id, soin_id, date);
    res.json({ creneaux });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getCoiffeusesPourLocation = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT c.*, u.nom, u.prenom, u.email, u.telephone, s.nom as salon_nom
      FROM coiffeuses c
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      JOIN salons s ON s.id = c.salon_id
      WHERE c.disponible_location = true
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getCoiffeusesPourDomicile = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT c.*, u.nom, u.prenom, u.email, u.telephone, s.nom as salon_nom
      FROM coiffeuses c
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      JOIN salons s ON s.id = c.salon_id
      WHERE c.disponible_domicile = true
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { getToutesCoiffeuses, getCoiffeuseById, getCreneaux, getCoiffeusesPourLocation, getCoiffeusesPourDomicile };