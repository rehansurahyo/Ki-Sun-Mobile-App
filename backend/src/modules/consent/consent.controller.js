const Users = require('../users/user.model');

// Hardcoded current versions for MVP. Move to DB if dynamic updates needed.
const CURRENT_VERSIONS = {
    terms_of_service: '1.0',
    privacy_policy: '1.0',
    studio_rules: '1.0'
};

const TERMS_TEXT = {
    terms_of_service: "These are the Terms of Service for Ki-Sun Tanning Studio. By using our app, you agree to...",
    privacy_policy: "Your privacy is important to us. This policy explains how we collect and use your data...",
    studio_rules: "1. No tanning under 18. \n2. Wear protective goggles. \n3. Clean bed after use."
};

exports.getLatestConsents = (req, res) => {
    res.json({
        versions: CURRENT_VERSIONS,
        documents: TERMS_TEXT
    });
};

exports.acceptConsents = async (req, res) => {
    try {
        const userId = req.user.id;
        const { accepted_versions } = req.body;
        // Expect: { terms_of_service: "1.0", privacy_policy: "1.0", studio_rules: "1.0" }

        if (!accepted_versions) {
            return res.status(400).json({ error: 'Missing accepted_versions' });
        }

        // Verify all required docs are accepted
        const required = Object.keys(CURRENT_VERSIONS);
        const missing = required.filter(key => accepted_versions[key] !== CURRENT_VERSIONS[key]);

        if (missing.length > 0) {
            return res.status(400).json({ error: `Must accept latest version of: ${missing.join(', ')}` });
        }

        const userRef = Users.doc(userId);
        await userRef.update({
            consents: accepted_versions,
            consent_completed: true,
            updatedAt: new Date()
        });

        res.json({ message: 'Consents updated', consent_completed: true });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error updating consents' });
    }
};

