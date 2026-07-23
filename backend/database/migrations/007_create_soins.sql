CREATE TABLE soins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type_soin_id UUID NOT NULL REFERENCES types_soins(id) ON DELETE CASCADE,
  nom VARCHAR(100) NOT NULL,
  description TEXT,
  duree_minutes INT NOT NULL,
  prix_salon DECIMAL(10,2) NOT NULL,
  prix_domicile DECIMAL(10,2)
);
