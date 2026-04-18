const { db } = require('../../config/firebase');

// Reference to 'studios' collection - assuming studios module has a model or needs one
const studiosCollection = db.collection('studios');

module.exports = studiosCollection;
