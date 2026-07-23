const pool = require('../config/db');

const creerLocation = async (req, res) => {
  const { coiffeuse_id, type_evenement, date_debut, date_fin, adresse_evenement, devise } = req.body;
  const cliente_id = req.utilisateur.id;
  try {
    const coiffeuse = await pool.query('SELECT * FROM coiffeuses WHERE id = $1', [coiffeuse_id]);
    if (coiffeuse.rows.length === 0) return res.status(404).json({ message: 'Coiffeuse non trouvée' });
    const d1 = new Date(date_debut);
    const d2 = new Date(date_fin);
    const nb_jours = Math.ceil((d2 - d1) / (1000 * 60 * 60 * 24)) + 1;
    const tarif = coiffeuse.rows[0].tarif_journee;
    const montant_total = devise === 'CDF' ? tarif * nb_jours * 2200 : tarif * nb_jours;
    const result = await pool.query(`
      INSERT INTO locations_coiffeuse (cliente_id, coiffeuse_id, type_evenement, date_debut, date_fin, nb_jours, adresse_evenement, montant_total, devise)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *
    `, [cliente_id, coiffeuse_id, type_evenement, date_debut, date_fin, nb_jours, adresse_evenement, montant_total, devise || 'USD']);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getMesLocations = async (req, res) => {
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      SELECT lc.*, u.nom as coiffeuse_nom, u.prenom as coiffeuse_prenom
      FROM locations_coiffeuse lc
      JOIN coiffeuses c ON c.id = lc.coiffeuse_id
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      WHERE lc.cliente_id = $1
      ORDER BY lc.date_debut DESC
    `, [cliente_id]);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const annulerLocation = async (req, res) => {
  const { id } = req.params;
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      UPDATE locations_coiffeuse SET statut = 'annulee'
      WHERE id = $1 AND cliente_id = $2
      RETURNING *
    `, [id, cliente_id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'Location non trouvée' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const payerLocation = async (req, res) => {
  const { id } = req.params;
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      UPDATE locations_coiffeuse SET statut_paiement = 'paye_demo'
      WHERE id = $1 AND cliente_id = $2
      RETURNING *
    `, [id, cliente_id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'Location non trouvée' });
    res.json({ message: 'Paiement simulé accepté', location: result.rows[0] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { creerLocation, getMesLocations, annulerLocation, payerLocation };