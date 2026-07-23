CREATE TYPE statut_reservation AS ENUM ('confirmee','annulee','terminee');
CREATE TYPE statut_paiement AS ENUM ('en_attente','paye_demo');

CREATE TABLE reservations_salon (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES utilisateurs(id),
  coiffeuse_id UUID NOT NULL REFERENCES coiffeuses(id),
  salon_id UUID NOT NULL REFERENCES salons(id),
  soin_id UUID NOT NULL REFERENCES soins(id),
  date_heure TIMESTAMP NOT NULL,
  statut statut_reservation DEFAULT 'confirmee',
  montant DECIMAL(10,2) NOT NULL,
  statut_paiement statut_paiement DEFAULT 'en_attente',
  created_at TIMESTAMP DEFAULT NOW()
);
