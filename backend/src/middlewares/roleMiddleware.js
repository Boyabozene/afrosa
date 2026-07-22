const verifierRole = (...rolesAutorises) => {
  return (req, res, next) => {
    if (!req.utilisateur) {
      return res.status(401).json({ message: 'Non authentifié' });
    }
    if (!rolesAutorises.includes(req.utilisateur.role)) {
      return res.status(403).json({ message: 'Accès refusé' });
    }
    next();
  };
};

module.exports = { verifierRole };