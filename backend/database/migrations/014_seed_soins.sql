cat > database/migrations/014_seed_soins.sql <<'EOF'
INSERT INTO gammes (nom, description)
SELECT 'Signature', 'Notre gamme premium de soins sur mesure'
WHERE NOT EXISTS (
  SELECT 1 FROM gammes WHERE nom = 'Signature'
);

INSERT INTO gammes (nom, description)
SELECT 'Naturelle', 'Soins doux aux ingrédients naturels'
WHERE NOT EXISTS (
  SELECT 1 FROM gammes WHERE nom = 'Naturelle'
);

INSERT INTO gammes (nom, description)
SELECT 'Événement', 'Coiffures élaborées pour vos occasions spéciales'
WHERE NOT EXISTS (
  SELECT 1 FROM gammes WHERE nom = 'Événement'
);

INSERT INTO types_soins (gamme_id, nom)
SELECT g.id, 'Tresses & Braids'
FROM gammes g
WHERE g.nom = 'Signature'
AND NOT EXISTS (
  SELECT 1 FROM types_soins t WHERE t.nom = 'Tresses & Braids'
);

INSERT INTO types_soins (gamme_id, nom)
SELECT g.id, 'Soins & Traitements'
FROM gammes g
WHERE g.nom = 'Naturelle'
AND NOT EXISTS (
  SELECT 1 FROM types_soins t WHERE t.nom = 'Soins & Traitements'
);

INSERT INTO types_soins (gamme_id, nom)
SELECT g.id, 'Tissage & Perruques'
FROM gammes g
WHERE g.nom = 'Signature'
AND NOT EXISTS (
  SELECT 1 FROM types_soins t WHERE t.nom = 'Tissage & Perruques'
);

INSERT INTO types_soins (gamme_id, nom)
SELECT g.id, 'Coiffures Événement'
FROM gammes g
WHERE g.nom = 'Événement'
AND NOT EXISTS (
  SELECT 1 FROM types_soins t WHERE t.nom = 'Coiffures Événement'
);

INSERT INTO soins (
  type_soin_id,
  nom,
  description,
  duree_minutes,
  prix_salon,
  prix_salon_cdf,
  prix_domicile,
  prix_domicile_cdf
)
SELECT
  t.id,
  v.nom,
  v.description,
  v.duree_minutes,
  v.prix_salon,
  v.prix_salon_cdf,
  v.prix_domicile,
  v.prix_domicile_cdf
FROM (
  VALUES
    ('Tresses & Braids', 'Box braids mi-longues', 'Tresses protectrices mi-longues', 240, 40.00, 112000.00, 55.00, 154000.00),
    ('Tresses & Braids', 'Box braids longues', 'Tresses protectrices longues', 360, 60.00, 168000.00, 80.00, 224000.00),
    ('Tresses & Braids', 'Vanilles / Twists', 'Twists naturels et élégants', 180, 30.00, 84000.00, 40.00, 112000.00),
    ('Soins & Traitements', 'Soin hydratant profond', 'Masque nourrissant et restructurant', 60, 12.00, 33600.00, 18.00, 50400.00),
    ('Soins & Traitements', 'Shampoing + Brushing', 'Lavage et mise en forme', 45, 10.00, 28000.00, 15.00, 42000.00),
    ('Soins & Traitements', 'Défrisage', 'Lissage chimique professionnel', 90, 18.00, 50400.00, 25.00, 70000.00),
    ('Tissage & Perruques', 'Tissage mi-long', 'Pose de tissage naturel', 120, 28.00, 78400.00, 38.00, 106400.00),
    ('Tissage & Perruques', 'Pose de perruque', 'Installation et coiffage perruque', 90, 22.00, 61600.00, 30.00, 84000.00),
    ('Coiffures Événement', 'Coiffure mariage', 'Coiffure élaborée pour mariée', 180, 80.00, 224000.00, 100.00, 280000.00),
    ('Coiffures Événement', 'Coiffure soirée', 'Mise en beauté pour soirée', 90, 30.00, 84000.00, 40.00, 112000.00)
) AS v(
  type_nom,
  nom,
  description,
  duree_minutes,
  prix_salon,
  prix_salon_cdf,
  prix_domicile,
  prix_domicile_cdf
)
JOIN types_soins t ON t.nom = v.type_nom
WHERE NOT EXISTS (
  SELECT 1 FROM soins s WHERE s.nom = v.nom
);
EOF