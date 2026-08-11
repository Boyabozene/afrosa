const pool = require('../config/db');

const calculerRemise = (nb) => {
  if (nb >= 4) return 20;
  if (nb === 3) return 15;
  if (nb === 2) return 10;
  return 0;
};

const creerReservationSalon = async (req, res) => {
  const { coiffeuse_id, salon_id, soin_id, date_heure, devise, nb_personnes } = req.body;
  const cliente_id = req.utilisateur.id;
  try {
    const soin = await pool.query('SELECT * FROM soins WHERE id = $1', [soin_id]);
    if (soin.rows.length === 0) return res.status(404).json({ message: 'Soin non trouvé' });
    const nb = nb_personnes && nb_personnes > 0 ? nb_personnes : 1;
    const remise = calculerRemise(nb);
    const prixUnitaire = devise === 'CDF' ? soin.rows[0].prix_salon_cdf : soin.rows[0].prix_salon;
    const montant = prixUnitaire * nb * (1 - remise / 100);
    const result = await pool.query(`
      INSERT INTO reservations_salon (cliente_id, coiffeuse_id, salon_id, soin_id, date_heure, montant, devise, nb_personnes, remise_pourcentage)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *
    `, [cliente_id, coiffeuse_id, salon_id, soin_id, date_heure, montant, devise || 'USD', nb, remise]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getMesReservationsSalon = async (req, res) => {
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      SELECT rs.*, s.nom as soin_nom, s.duree_minutes,
        sa.nom as salon_nom, sa.adresse,
        u.nom as coiffeuse_nom, u.prenom as coiffeuse_prenom
      FROM reservations_salon rs
      JOIN soins s ON s.id = rs.soin_id
      JOIN salons sa ON sa.id = rs.salon_id
      JOIN coiffeuses c ON c.id = rs.coiffeuse_id
      JOIN utilisateurs u ON u.id = c.utilisateur_id
      WHERE rs.cliente_id = $1
      ORDER BY rs.date_heure DESC
    `, [cliente_id]);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const annulerReservationSalon = async (req, res) => {
  const { id } = req.params;
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      UPDATE reservations_salon SET statut = 'annulee'
      WHERE id = $1 AND cliente_id = $2
      RETURNING *
    `, [id, cliente_id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'Réservation non trouvée' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const payerReservationSalon = async (req, res) => {
  const { id } = req.params;
  const { mode_paiement } = req.body;
  const cliente_id = req.utilisateur.id;
  try {
    const result = await pool.query(`
      UPDATE reservations_salon SET statut_paiement = 'paye_demo'
      WHERE id = $1 AND cliente_id = $2
      RETURNING *
    `, [id, cliente_id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'Réservation non trouvée' });
    res.json({ message: 'Paiement simulé accepté', reservation: result.rows[0] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { creerReservationSalon, getMesReservationsSalon, annulerReservationSalon, payerReservationSalon };