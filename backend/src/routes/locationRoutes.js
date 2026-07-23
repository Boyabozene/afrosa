const express = require('express');
const router = express.Router();
const { creerLocation, getMesLocations, annulerLocation, payerLocation } = require('../controllers/locationController');
const { verifierToken } = require('../middlewares/authMiddleware');

router.use(verifierToken);
router.post('/', creerLocation);
router.get('/mes-locations', getMesLocations);
router.patch('/:id/annuler', annulerLocation);
router.patch('/:id/payer', payerLocation);

module.exports = router;