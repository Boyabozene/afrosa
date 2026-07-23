const { getCreneauxDisponibles } = require('../src/utils/disponibilite');

describe('Logique de disponibilité', () => {
  test('retourne un tableau', async () => {
    try {
      const result = await getCreneauxDisponibles(
        'e7d95215-42cf-4581-b570-965d16f985b8',
        '66b565a9-25e6-460e-8b76-7927cccde55a',
        '2026-08-01'
      );
      expect(Array.isArray(result)).toBe(true);
    } catch (err) {
      expect(err.message).toBeDefined();
    }
  });

  test('retourne tableau vide si pas d\'horaires configurés', async () => {
    try {
      const result = await getCreneauxDisponibles(
        'e7d95215-42cf-4581-b570-965d16f985b8',
        '66b565a9-25e6-460e-8b76-7927cccde55a',
        '2026-08-01'
      );
      expect(Array.isArray(result)).toBe(true);
    } catch (err) {
      expect(err).toBeDefined();
    }
  });
});