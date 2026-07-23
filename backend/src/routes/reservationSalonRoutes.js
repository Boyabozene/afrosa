const express = require('express');
const router = express.Router();
const { creerReservationSalon, getMesReservationsSalon, annulerReservationSalon, payerReservationSalon } = require('../controllers/reservationSalonController');
const { verifierToken } = require('../middlewares/authMiddleware');

router.use(verifierToken);
router.post('/', creerReservationSalon);
router.get('/mes-reservations', getMesReservationsSalon);
router.patch('/:id/annuler', annulerReservationSalon);
router.patch('/:id/payer', payerReservationSalon);

module.exports = router;