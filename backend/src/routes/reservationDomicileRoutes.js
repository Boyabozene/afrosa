const express = require('express');
const router = express.Router();
const { creerReservationDomicile, getMesReservationsDomicile, annulerReservationDomicile, payerReservationDomicile } = require('../controllers/reservationDomicileController');
const { verifierToken } = require('../middlewares/authMiddleware');

router.use(verifierToken);
router.post('/', creerReservationDomicile);
router.get('/mes-reservations', getMesReservationsDomicile);
router.patch('/:id/annuler', annulerReservationDomicile);
router.patch('/:id/payer', payerReservationDomicile);

module.exports = router;