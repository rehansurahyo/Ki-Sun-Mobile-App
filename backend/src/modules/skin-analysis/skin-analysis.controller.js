const Users = require('../users/user.model');

const calculateSkinType = (score) => {
    if (score <= 7) return 'I';
    if (score <= 14) return 'II';
    if (score <= 21) return 'III';
    if (score <= 28) return 'IV';
    return 'V'; // 29-40 (V-VI)
};

exports.submitAnalysis = async (req, res) => {
    try {
        const userId = req.user.id;
        const { answers, total_score } = req.body;
        // Expect: { answers: { eye_color: 2, hair_color: 3 ... }, total_score: 25 }

        if (total_score === undefined) {
            return res.status(400).json({ error: 'Missing total_score' });
        }

        const skinType = calculateSkinType(total_score);

        const userRef = Users.doc(userId);
        const userDoc = await userRef.get();
        const userData = userDoc.exists ? userDoc.data() : {};

        await userRef.update({
            skin_type: skinType,
            skin_analysis_data: {
                answers,
                score: total_score,
                date: new Date()
            },
            skin_analysis_completed: true,
            updatedAt: new Date()
        });

        // Use userData.sun_allowed if it exists, or logic to determine usage
        // Mongoose default was implicitly handled or null.
        // Assuming sun_allowed is stored in user doc.

        res.json({
            message: 'Skin analysis completed',
            skin_type: skinType,
            sun_allowed: userData.sun_allowed // might be undefined if not in DB
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error processing skin analysis' });
    }
};

