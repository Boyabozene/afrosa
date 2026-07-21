CREATE TABLE types_soins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  gamme_id UUID NOT NULL REFERENCES gammes(id) ON DELETE CASCADE,
  nom VARCHAR(100) NOT NULL
);
