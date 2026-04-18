const Cabins = require('./cabin.model');

// Get All Cabins
exports.getAllCabins = async (req, res) => {
    try {
        const snapshot = await Cabins.orderBy('code').get();
        const cabins = snapshot.docs.map(doc => ({
            _id: doc.id,
            ...doc.data()
        }));
        res.status(200).json(cabins);
    } catch (error) {
        console.error('Error fetching cabins:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

// Get Cabin by ID
exports.getCabinById = async (req, res) => {
    try {
        const doc = await Cabins.doc(req.params.id).get();
        if (!doc.exists) return res.status(404).json({ error: 'Cabin not found' });

        const cabin = {
            _id: doc.id,
            ...doc.data()
        };
        res.status(200).json(cabin);
    } catch (error) {
        console.error('Error fetching cabin:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

