CREATE TABLE coiffeuses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  utilisateur_id UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
  salon_id UUID NOT NULL REFERENCES salons(id),
  bio TEXT,
  photo_url VARCHAR(255),
  disponible_domicile BOOLEAN DEFAULT false,
  disponible_location BOOLEAN DEFAULT false,
  tarif_journee DECIMAL(10,2)
);
