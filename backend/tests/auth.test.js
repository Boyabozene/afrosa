const request = require('supertest');
const app = require('../src/app');

describe('Auth API', () => {
  test('POST /api/auth/inscription - crée un nouvel utilisateur', async () => {
    const res = await request(app)
      .post('/api/auth/inscription')
      .send({
        nom: 'Testeur',
        prenom: 'Auto',
        email: `test_${Date.now()}@afrosa.cd`,
        mot_de_passe: 'password123',
        telephone: '+243810000099'
      });
    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('token');
    expect(res.body.utilisateur).toHaveProperty('email');
    expect(res.body.utilisateur.role).toBe('cliente');
  });

  test('POST /api/auth/connexion - connecte un utilisateur existant', async () => {
    const res = await request(app)
      .post('/api/auth/connexion')
      .send({
        email: 'test@afrosa.cd',
        mot_de_passe: 'password123'
      });
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('token');
    expect(res.body.utilisateur.email).toBe('test@afrosa.cd');
  });

  test('POST /api/auth/connexion - rejette un mauvais mot de passe', async () => {
    const res = await request(app)
      .post('/api/auth/connexion')
      .send({
        email: 'test@afrosa.cd',
        mot_de_passe: 'mauvais_mdp'
      });
    expect(res.statusCode).toBe(401);
    expect(res.body).toHaveProperty('message');
  });

  test('GET route protégée sans token - retourne 401', async () => {
    const res = await request(app)
      .get('/api/reservations/salon/mes-reservations');
    expect(res.statusCode).toBe(401);
  });
});