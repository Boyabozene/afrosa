const pool = require('../config/db');

const creerReservationDomicile = async (req, res) => {
  const { coiffeuse_id, soin_id, adresse_cliente, date_heure, devise } = req.body;
  const cliente_id = req.utilisateur.id;
  try {
    const soin = await pool.query('SELECT * FROM soins WHERE id = $1', [soin_id]);
    if (soin.rows.length === 0) return res.status(404).json({ message: 'Soin non trouvé' });
    const montant = devise === 'CDF' ? soin.rows[0].prix_domicile_cdf : soin.rows[0].prix_domicile;
    const result = await pool.query(`
      INSERT INTO reservations_domicile (cliente_id, coiffeuse_id, soin_id, adresse_cliente, date_heure, montant, devise)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
    `, [cliente_id, coiffeuse_id, soin_id, adresse_cliente, date_heure, montant, devise || 'USD']);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getMesReservationsDomicile = async (req, res) => {
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      SELECT rd.*, s.nom as soin_nom, s.duree_minutes,
        u.nom as coiffeuse_nom, u.prenom as coiffeuse_prenom
      FROM reservations_domicile rd
      JOIN soins s ON s.id = rd.soin_id
      JOIN coiffeuses c ON c.id = rd.coiffeuse_id
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      WHERE rd.cliente_id = $1
      ORDER BY rd.date_heure DESC
    `, [cliente_id]);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const annulerReservationDomicile = async (req, res) => {
  const { id } = req.params;
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      UPDATE reservations_domicile SET statut = 'annulee'
      WHERE id = $1 AND cliente_id = $2
      RETURNING *
    `, [id, cliente_id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'Réservation non trouvée' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const payerReservationDomicile = async (req, res) => {
  const { id } = req.params;
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      UPDATE reservations_domicile SET statut_paiement = 'paye_demo'
      WHERE id = $1 AND cliente_id = $2
      RETURNING *
    `, [id, cliente_id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'Réservation non trouvée' });
    res.json({ message: 'Paiement simulé accepté', reservation: result.rows[0] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { creerReservationDomicile, getMesReservationsDomicile, annulerReservationDomicile, payerReservationDomicile };