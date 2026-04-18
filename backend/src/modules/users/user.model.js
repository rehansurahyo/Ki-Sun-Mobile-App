const { db } = require('../../config/firebase');

// Reference to 'users' collection
const usersCollection = db.collection('users');

module.exports = usersCollection;
