const express = require('express');
const router = express.Router();
const consentController = require('./consent.controller');
const authMiddleware = require('../../middlewares/auth.middleware');

router.get('/latest', consentController.getLatestConsents); // Public or Protected? Let's make it public/semi-public
router.post('/accept', authMiddleware, consentController.acceptConsents);

module.exports = router;
