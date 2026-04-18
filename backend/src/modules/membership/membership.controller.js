const Users = require('../users/user.model');

const PLANS = [
    {
        id: 'basic',
        name: 'Basic',
        price: 19.99,
        duration_minutes: 10,
        benefits: ['10 mins/session', 'Access to Standard Beds', 'Valid for 1 Month']
    },
    {
        id: 'premium',
        name: 'Premium',
        price: 39.99,
        duration_minutes: 20,
        benefits: ['20 mins/session', 'Access to Premium Beds', 'Priority Booking', 'Valid for 1 Month']
    },
    {
        id: 'unlimited',
        name: 'Unlimited',
        price: 59.99,
        duration_minutes: 30, // Or truly unlimited subject to safety
        benefits: ['Max safety duration', 'Access to All Beds', 'Free Lotions', 'Valid for 1 Month']
    }
];

exports.getPlans = (req, res) => {
    res.json({ plans: PLANS });
};

exports.subscribe = async (req, res) => {
    try {
        const userId = req.user.id;
        const { plan_id, payment_method_id } = req.body; // mock payment_method_id for now

        const plan = PLANS.find(p => p.id === plan_id);
        if (!plan) return res.status(400).json({ error: 'Invalid plan_id' });

        // Mock Payment Processing
        // await stripe.charges.create({...})

        const userRef = Users.doc(userId);
        const userDoc = await userRef.get();

        if (!userDoc.exists) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Set Expiry (1 Month from now)
        const expiryDate = new Date();
        expiryDate.setMonth(expiryDate.getMonth() + 1);

        const membershipData = {
            type: plan.id,
            status: 'active',
            expiry_date: expiryDate
        };

        await userRef.update({
            membership: membershipData,
            updatedAt: new Date()
        });

        res.json({
            message: `Subscribed to ${plan.name} successfully`,
            membership: membershipData
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error processing subscription' });
    }
};

