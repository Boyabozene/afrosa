const express = require('express');
const router = express.Router();
const { getTousSalons, getSalonById, getCoiffeusesDuSalon } = require('../controllers/salonController');

router.get('/', getTousSalons);
router.get('/:id', getSalonById);
router.get('/:id/coiffeuses', getCoiffeusesDuSalon);

module.exports = router;