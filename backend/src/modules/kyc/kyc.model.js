const { db } = require('../../config/firebase');

// Reference to 'kyc' collection
const kycCollection = db.collection('kyc');

module.exports = kycCollection;
