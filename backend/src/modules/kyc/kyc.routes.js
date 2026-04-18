const express = require('express');
const router = express.Router();
const kycController = require('./kyc.controller');
const protect = require('../../middlewares/auth.middleware');

router.post('/initiate', protect, kycController.initiate);
router.post('/mock-result', protect, kycController.verifyMock);

module.exports = router;
