CREATE TABLE locations_coiffeuse (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES utilisateurs(id),
  coiffeuse_id UUID NOT NULL REFERENCES coiffeuses(id),
  type_evenement VARCHAR(100) NOT NULL,
  date_debut DATE NOT NULL,
  date_fin DATE NOT NULL,
  nb_jours INT NOT NULL,
  adresse_evenement TEXT NOT NULL,
  statut statut_reservation DEFAULT 'confirmee',
  montant_total DECIMAL(10,2) NOT NULL,
  statut_paiement statut_paiement DEFAULT 'en_attente',
  created_at TIMESTAMP DEFAULT NOW()
);
