const express = require('express');
const router = express.Router();
const membershipController = require('./membership.controller');
const auth = require('../../middlewares/auth.middleware');

// GET /api/membership/plans
router.get('/plans', membershipController.getPlans);

// POST /api/membership/subscribe
router.post('/subscribe', auth, membershipController.subscribe);

module.exports = router;
