const pool = require('../config/db');

const getTousGammes = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT g.*,
        json_agg(json_build_object(
          'id', t.id,
          'nom', t.nom
        )) as types_soins
      FROM gammes g
      LEFT JOIN types_soins t ON t.gamme_id = g.id
      GROUP BY g.id
      ORDER BY g.nom
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getSoinsByType = async (req, res) => {
  try {
    const { type_id } = req.params;
    const result = await pool.query(
      'SELECT * FROM soins WHERE type_soin_id = $1 ORDER BY nom',
      [type_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getTousSoins = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT s.*, t.nom as type_nom, g.nom as gamme_nom
      FROM soins s
      JOIN types_soins t ON t.id = s.type_soin_id
      JOIN gammes g ON g.id = t.gamme_id
      ORDER BY g.nom, t.nom, s.nom
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { getTousGammes, getSoinsByType, getTousSoins };