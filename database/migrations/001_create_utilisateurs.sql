CREATE TYPE role_utilisateur AS ENUM ('cliente', 'coiffeuse', 'admin');

CREATE TABLE utilisateurs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  mot_de_passe VARCHAR(255) NOT NULL,
  telephone VARCHAR(20),
  role role_utilisateur NOT NULL DEFAULT 'cliente',
  created_at TIMESTAMP DEFAULT NOW()
);
