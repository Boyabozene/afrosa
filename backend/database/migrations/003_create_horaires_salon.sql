CREATE TYPE jour_semaine AS ENUM ('lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche');

CREATE TABLE horaires_salon (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,
  jour jour_semaine NOT NULL,
  heure_ouverture TIME NOT NULL,
  heure_fermeture TIME NOT NULL
);
