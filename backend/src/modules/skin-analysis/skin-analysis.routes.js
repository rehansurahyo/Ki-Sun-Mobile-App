const express = require('express');
const router = express.Router();
const skinAnalysisController = require('./skin-analysis.controller');
const authMiddleware = require('../../middlewares/auth.middleware');

router.post('/submit', authMiddleware, skinAnalysisController.submitAnalysis);

module.exports = router;
