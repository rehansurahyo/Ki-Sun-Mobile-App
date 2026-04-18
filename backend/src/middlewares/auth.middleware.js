const { admin } = require('../config/firebase');
// const jwt = require('jsonwebtoken'); // Not needed for Firebase Auth check

const verifyToken = async (req, res, next) => {
    const authHeader = req.headers['authorization'];

    if (!authHeader) {
        return res.status(403).json({ error: 'No token provided' });
    }

    const token = authHeader.split(' ')[1]; // Bearer <token>

    if (!token) {
        return res.status(403).json({ error: 'Malformed token' });
    }

    try {
        // Verify Firebase ID Token
        const decodedToken = await admin.auth().verifyIdToken(token);

        // Match existing structure expected by controllers (req.user.id or req.user.uid)
        req.user = {
            id: decodedToken.uid, // Map uid to id for compatibility
            uid: decodedToken.uid,
            phone_number: decodedToken.phone_number,
            email: decodedToken.email
        };

        next();
    } catch (err) {
        console.error('Auth Error:', err.message);
        return res.status(401).json({ error: 'Unauthorized: Invalid token' });
    }
};

module.exports = verifyToken;
