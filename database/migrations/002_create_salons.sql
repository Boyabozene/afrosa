CREATE TABLE salons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nom VARCHAR(100) NOT NULL,
  adresse TEXT NOT NULL,
  ville VARCHAR(100) NOT NULL,
  telephone VARCHAR(20),
  photo_url VARCHAR(255)
);
