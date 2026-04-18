const express = require('express');
const router = express.Router();
const customerController = require('./customer.controller');

// POST /api/customers - Create or Update Customer
router.post('/', customerController.createOrUpdateCustomer);

// GET /api/customers - Get All Customers (Verification)
router.get('/', customerController.getAllCustomers);

module.exports = router;
