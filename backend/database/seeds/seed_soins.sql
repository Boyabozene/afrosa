INSERT INTO gammes (nom, description) VALUES
('Signature', 'Notre gamme premium de soins sur mesure'),
('Naturelle', 'Soins doux aux ingrédients naturels'),
('Événement', 'Coiffures élaborées pour vos occasions spéciales');

INSERT INTO types_soins (gamme_id, nom)
SELECT id, 'Tresses & Braids' FROM gammes WHERE nom = 'Signature'
UNION ALL
SELECT id, 'Soins & Traitements' FROM gammes WHERE nom = 'Naturelle'
UNION ALL
SELECT id, 'Tissage & Perruques' FROM gammes WHERE nom = 'Signature'
UNION ALL
SELECT id, 'Coiffures Événement' FROM gammes WHERE nom = 'Événement';

INSERT INTO soins (type_soin_id, nom, description, duree_minutes, prix_salon, prix_salon_cdf, prix_domicile, prix_domicile_cdf)
SELECT id, 'Box braids mi-longues', 'Tresses protectrices mi-longues', 240, 40.00, 112000.00, 55.00, 154000.00
FROM types_soins WHERE nom = 'Tresses & Braids'
UNION ALL
SELECT id, 'Box braids longues', 'Tresses protectrices longues', 360, 60.00, 168000.00, 80.00, 224000.00
FROM types_soins WHERE nom = 'Tresses & Braids'
UNION ALL
SELECT id, 'Vanilles / Twists', 'Twists naturels et élégants', 180, 30.00, 84000.00, 40.00, 112000.00
FROM types_soins WHERE nom = 'Tresses & Braids'
UNION ALL
SELECT id, 'Soin hydratant profond', 'Masque nourrissant et restructurant', 60, 12.00, 33600.00, 18.00, 50400.00
FROM types_soins WHERE nom = 'Soins & Traitements'
UNION ALL
SELECT id, 'Shampoing + Brushing', 'Lavage et mise en forme', 45, 10.00, 28000.00, 15.00, 42000.00
FROM types_soins WHERE nom = 'Soins & Traitements'
UNION ALL
SELECT id, 'Défrisage', 'Lissage chimique professionnel', 90, 18.00, 50400.00, 25.00, 70000.00
FROM types_soins WHERE nom = 'Soins & Traitements'
UNION ALL
SELECT id, 'Tissage mi-long', 'Pose de tissage naturel', 120, 28.00, 78400.00, 38.00, 106400.00
FROM types_soins WHERE nom = 'Tissage & Perruques'
UNION ALL
SELECT id, 'Pose de perruque', 'Installation et coiffage perruque', 90, 22.00, 61600.00, 30.00, 84000.00
FROM types_soins WHERE nom = 'Tissage & Perruques'
UNION ALL
SELECT id, 'Coiffure mariage', 'Coiffure élaborée pour mariée', 180, 80.00, 224000.00, 100.00, 280000.00
FROM types_soins WHERE nom = 'Coiffures Événement'
UNION ALL
SELECT id, 'Coiffure soirée', 'Mise en beauté pour soirée', 90, 30.00, 84000.00, 40.00, 112000.00
FROM types_soins WHERE nom = 'Coiffures Événement';
