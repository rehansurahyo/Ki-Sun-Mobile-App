const express = require('express');
const router = express.Router();
const bookingController = require('./booking.controller');

router.post('/', bookingController.createBooking);
router.get('/my', bookingController.getMyBookings);

module.exports = router;
