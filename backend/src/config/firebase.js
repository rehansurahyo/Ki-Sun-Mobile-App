const admin = require('firebase-admin');
const dotenv = require('dotenv');

dotenv.config();

const serviceAccountPath = require('path').join(__dirname, '../../ki-sun-lounge-app-firebase-adminsdk-fbsvc-bca2bb1f24.json');
const fs = require('fs');

if (!admin.apps.length) {
    try {
        let credential;
        if (fs.existsSync(serviceAccountPath)) {
            console.log('🔑 Found serviceAccountKey.json, using it for authentication.');
            const serviceAccount = require(serviceAccountPath);
            credential = admin.credential.cert(serviceAccount);
        } else {
            console.log('⚠️ serviceAccountKey.json not found, falling back to Google Application Credentials.');
            credential = admin.credential.applicationDefault();
        }

        admin.initializeApp({
            credential: credential
        });
        console.log('🔥 Firebase Admin Initialized');
    } catch (error) {
        console.error('❌ Firebase Admin Initialization Error:', error.message);
        console.error('Please ensure GOOGLE_APPLICATION_CREDENTIALS environment variable is set OR place serviceAccountKey.json in the backend root folder.');
    }
}

const db = admin.firestore();

module.exports = { admin, db };
