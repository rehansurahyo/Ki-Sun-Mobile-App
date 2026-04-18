const Users = require('./user.model');
const crypto = require('crypto');

exports.createPreAccount = async (req, res) => {
    try {
        const { device_uuid, studio_id, campaign_id, device_info } = req.body;

        const uuidToUse = device_uuid || crypto.randomUUID();

        // Check if user exists by device_uuid
        const snapshot = await Users.where('uuid', '==', uuidToUse).limit(1).get();

        if (!snapshot.empty) {
            // Update existing user
            const doc = snapshot.docs[0];
            const userId = doc.id;

            await Users.doc(userId).update({
                studio_id: studio_id || doc.data().studio_id,
                campaign_id: campaign_id || doc.data().campaign_id,
                updatedAt: new Date()
            });

            return res.status(200).json({ message: 'User found', user_id: userId, is_new: false });
        }

        // Create new Pre-Account
        const newUser = {
            uuid: uuidToUse,
            studio_id,
            campaign_id,
            device_info,
            app_installed: true,
            createdAt: new Date(),
            updatedAt: new Date()
        };

        const docRef = await Users.add(newUser);

        res.status(201).json({
            message: 'Pre-account created successfully',
            user_id: docRef.id,
            is_new: true
        });

    } catch (error) {
        console.error('Create Pre-Account Error:', error);
        res.status(500).json({ error: 'Server error creating pre-account' });
    }
};

