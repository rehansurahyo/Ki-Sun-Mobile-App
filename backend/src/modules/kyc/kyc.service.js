const KYCs = require('./kyc.model');
const Users = require('../users/user.model');

// Mock Provider Service - Replace with Real SDK later
class KYCService {

    static calculateAge(dob) {
        const diff_ms = Date.now() - new Date(dob).getTime();
        const age_dt = new Date(diff_ms);
        return Math.abs(age_dt.getUTCFullYear() - 1970);
    }

    static async initiateVerification(userId, provider = 'MOCK') {
        // In real world: Call Provider API to get a session/link
        // Here: Create a record
        const kycData = {
            user_id: userId,
            provider,
            status: 'pending',
            createdAt: new Date(),
            updatedAt: new Date()
        };
        const docRef = await KYCs.add(kycData);
        return { _id: docRef.id, ...kycData };
    }

    static async processMockResult(kycId, mockData) {
        // mockData: { dob: '2000-01-01', outcome: 'success' }

        const kycDoc = await KYCs.doc(kycId).get();
        if (!kycDoc.exists) throw new Error('KYC not found');

        const kycData = kycDoc.data();
        const age = this.calculateAge(mockData.dob);
        const isAdult = age >= 18;

        const updates = {
            dob: new Date(mockData.dob),
            age: age,
            is_adult: isAdult,
            raw_response: mockData,
            updatedAt: new Date()
        };

        let userUpdate = null;

        if (isAdult && mockData.outcome === 'success') {
            updates.status = 'verified';
            updates.verifiedAt = new Date();

            userUpdate = {
                id_verified: true,
                'kyc_data.dob': updates.dob,
                'kyc_data.is_adult': true,
                updatedAt: new Date()
            };
        } else {
            updates.status = 'failed';
            updates.rejection_reason = !isAdult ? 'Under 18' : 'Verification Failed';
        }

        await KYCs.doc(kycId).update(updates);

        if (userUpdate) {
            await Users.doc(kycData.user_id).update(userUpdate);
        }

        return { _id: kycId, ...kycData, ...updates };
    }
}

module.exports = KYCService;

