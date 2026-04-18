const express = require('express');
const router = express.Router();
const cabinController = require('./cabin.controller');

router.get('/', cabinController.getAllCabins);
router.get('/:id', cabinController.getCabinById);

module.exports = router;
