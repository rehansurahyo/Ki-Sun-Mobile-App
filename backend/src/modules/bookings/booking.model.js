const { db } = require('../../config/firebase');

// Reference to 'bookings' collection
const bookingsCollection = db.collection('bookings');

module.exports = bookingsCollection;
