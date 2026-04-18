const KYCService = require('./kyc.service');

exports.initiate = async (req, res) => {
    try {
        // req.user from auth middleware
        const result = await KYCService.initiateVerification(req.user._id);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.verifyMock = async (req, res) => {
    try {
        const { kycId, dob, outcome } = req.body;
        const result = await KYCService.processMockResult(kycId, { dob, outcome });
        res.json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
