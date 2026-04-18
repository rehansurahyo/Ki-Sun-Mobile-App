const Users = require('../users/user.model');
const jwt = require('jsonwebtoken');
const OtpService = require('../../utils/otp.service');
const crypto = require('crypto');

const generateTokens = (userId) => {
    const accessToken = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_ACCESS_EXPIRATION || '15m'
    });
    const refreshToken = jwt.sign({ id: userId }, process.env.JWT_REFRESH_SECRET, {
        expiresIn: process.env.JWT_REFRESH_EXPIRATION || '7d'
    });
    return { accessToken, refreshToken };
};

exports.sendOtp = async (req, res) => {
    try {
        const { phone } = req.body; // or email
        if (!phone) return res.status(400).json({ error: 'Phone number required' });

        OtpService.generateOtp(phone);
        res.json({ message: 'OTP sent successfully' });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error sending OTP' });
    }
};

exports.verifyOtp = async (req, res) => {
    try {
        const { phone, code, device_uuid } = req.body;

        const isValid = OtpService.verifyOtp(phone, code);
        if (!isValid) return res.status(400).json({ error: 'Invalid or expired OTP' });

        // Find User by Phone
        let snapshot = await Users.where('phone', '==', phone).limit(1).get();
        let userDoc;
        let userId;

        if (!snapshot.empty) {
            userDoc = snapshot.docs[0];
            userId = userDoc.id;
        }

        // If not found by phone, try finding by device_uuid (merge scenario)
        if (!userDoc && device_uuid) {
            snapshot = await Users.where('uuid', '==', device_uuid).limit(1).get();
            if (!snapshot.empty) {
                userDoc = snapshot.docs[0];
                userId = userDoc.id;
            }
        }

        let userData = userDoc ? userDoc.data() : {};

        if (!userDoc) {
            // Create new user
            userData = {
                uuid: device_uuid || crypto.randomUUID(),
                phone,
                app_installed: true,
                createdAt: new Date(),
                updatedAt: new Date()
            };
            const docRef = await Users.add(userData);
            userId = docRef.id;
        } else {
            // Update existing
            await Users.doc(userId).update({
                phone,
                app_installed: true,
                updatedAt: new Date()
            });
            // Merge updated fields into userData for response
            userData.phone = phone;
            userData.app_installed = true;
        }

        // Prepare user object for response (map _id)
        const userObj = { _id: userId, ...userData };

        const tokens = generateTokens(userId);
        res.json({ message: 'Login successful', ...tokens, user: userObj });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error verifying OTP' });
    }
};

