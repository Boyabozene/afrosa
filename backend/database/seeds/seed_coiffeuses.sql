INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, telephone, role) VALUES
('Diallo', 'Aminata', 'aminata@afrosa.cd', '$2b$10$placeholder_hash', '+243810000001', 'coiffeuse'),
('Mbaye', 'Fatou', 'fatou@afrosa.cd', '$2b$10$placeholder_hash', '+243810000002', 'coiffeuse'),
('Kouassi', 'Binta', 'binta@afrosa.cd', '$2b$10$placeholder_hash', '+243810000003', 'coiffeuse'),
('Kabila', 'Admin', 'admin@afrosa.cd', '$2b$10$placeholder_hash', '+243810000000', 'admin'),
('Mutombo', 'Grace', 'grace@gmail.com', '$2b$10$placeholder_hash', '+243810000004', 'cliente');

INSERT INTO coiffeuses (utilisateur_id, salon_id, bio, disponible_domicile, disponible_location, tarif_journee)
SELECT u.id, s.id, 'Spécialiste tresses et soins naturels, 5 ans d''expérience.', true, true, 50.00
FROM utilisateurs u, salons s
WHERE u.email = 'aminata@afrosa.cd' AND s.nom = 'Afrosa Gombe';

INSERT INTO coiffeuses (utilisateur_id, salon_id, bio, disponible_domicile, disponible_location, tarif_journee)
SELECT u.id, s.id, 'Experte tissage et perruques, coiffures de mariée.', true, true, 60.00
FROM utilisateurs u, salons s
WHERE u.email = 'fatou@afrosa.cd' AND s.nom = 'Afrosa Kinshasa';

INSERT INTO coiffeuses (utilisateur_id, salon_id, bio, disponible_domicile, disponible_location, tarif_journee)
SELECT u.id, s.id, 'Passionnée de locks et coiffures naturelles.', false, true, 45.00
FROM utilisateurs u, salons s
WHERE u.email = 'binta@afrosa.cd' AND s.nom = 'Afrosa Ngaliema';
