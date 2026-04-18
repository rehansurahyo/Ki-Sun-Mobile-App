const { db } = require('../../config/firebase');

// Reference to 'cabins' collection
const cabinsCollection = db.collection('cabins');

module.exports = cabinsCollection;
