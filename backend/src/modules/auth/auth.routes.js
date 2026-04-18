const express = require('express');
const router = express.Router();
const authController = require('./auth.controller');

router.post('/send-otp', authController.sendOtp);
router.post('/verify-otp', authController.verifyOtp);
// router.post('/refresh', authController.refresh); // TODO later

module.exports = router;
