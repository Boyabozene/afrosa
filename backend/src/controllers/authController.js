const pool = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const inscription = async (req, res) => {
  const { nom, prenom, email, mot_de_passe, telephone, role } = req.body;
  try {
    const existant = await pool.query('SELECT id FROM utilisateurs WHERE email = $1', [email]);
    if (existant.rows.length > 0) {
      return res.status(400).json({ message: 'Email déjà utilisé' });
    }
    const hash = await bcrypt.hash(mot_de_passe, 10);
    const result = await pool.query(
      `INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, telephone, role)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, nom, prenom, email, role`,
      [nom, prenom, email, hash, telephone, role || 'cliente']
    );
    const utilisateur = result.rows[0];
    const token = jwt.sign(
      { id: utilisateur.id, role: utilisateur.role },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );
    res.status(201).json({ utilisateur, token });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const connexion = async (req, res) => {
  const { email, mot_de_passe } = req.body;
  try {
    const result = await pool.query('SELECT * FROM utilisateurs WHERE email = $1', [email]);
    if (result.rows.length === 0) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
    }
    const utilisateur = result.rows[0];
    const valide = await bcrypt.compare(mot_de_passe, utilisateur.mot_de_passe);
    if (!valide) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
    }
    const token = jwt.sign(
      { id: utilisateur.id, role: utilisateur.role },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );
    res.json({
      utilisateur: {
        id: utilisateur.id,
        nom: utilisateur.nom,
        prenom: utilisateur.prenom,
        email: utilisateur.email,
        role: utilisateur.role
      },
      token
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { inscription, connexion };