const { db } = require('../../config/firebase');

// Reference to 'customers' collection
const customersCollection = db.collection('customers');

module.exports = customersCollection;
