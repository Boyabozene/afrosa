const express = require('express');
const router = express.Router();
const { getTousGammes, getSoinsByType, getTousSoins } = require('../controllers/soinController');

router.get('/', getTousSoins);
router.get('/gammes', getTousGammes);
router.get('/type/:type_id', getSoinsByType);

module.exports = router;