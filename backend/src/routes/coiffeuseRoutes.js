const express = require('express');
const router = express.Router();
const { getToutesCoiffeuses, getCoiffeuseById, getCreneaux, getCoiffeusesPourLocation, getCoiffeusesPourDomicile } = require('../controllers/coiffeuseController');
const { verifierToken } = require('../middlewares/authMiddleware');

router.get('/', getToutesCoiffeuses);
router.get('/location', getCoiffeusesPourLocation);
router.get('/domicile', getCoiffeusesPourDomicile);
router.get('/:id', getCoiffeuseById);
router.get('/:id/creneaux', verifierToken, getCreneaux);

module.exports = router;