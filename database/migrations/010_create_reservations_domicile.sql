CREATE TABLE reservations_domicile (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES utilisateurs(id),
  coiffeuse_id UUID NOT NULL REFERENCES coiffeuses(id),
  soin_id UUID NOT NULL REFERENCES soins(id),
  adresse_cliente TEXT NOT NULL,
  date_heure TIMESTAMP NOT NULL,
  statut statut_reservation DEFAULT 'confirmee',
  montant DECIMAL(10,2) NOT NULL,
  statut_paiement statut_paiement DEFAULT 'en_attente',
  created_at TIMESTAMP DEFAULT NOW()
);
