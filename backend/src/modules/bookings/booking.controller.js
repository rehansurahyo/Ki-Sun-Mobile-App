const Bookings = require('./booking.model');
const Cabins = require('../cabins/cabin.model');
const Customers = require('../customers/customer.model');

// Create Booking
exports.createBooking = async (req, res) => {
    try {
        const {
            cabinId,
            customerPhone,
            date,
            startTime,
            minutes,
            ratePerMinute,
            totalAmount
        } = req.body;

        // Validate totalAmount (using rounding to avoid float precision issues)
        const calculatedTotalAmount = minutes * ratePerMinute;
        if (Math.round(totalAmount) !== Math.round(calculatedTotalAmount)) {
            return res.status(400).json({ error: 'Total amount mismatch with minutes and rate' });
        }

        // 1. Verify Cabin & Rate
        const cabinDoc = await Cabins.doc(cabinId).get();
        if (!cabinDoc.exists) return res.status(404).json({ error: 'Cabin not found' });
        // const cabin = cabinDoc.data();

        // 2. Verify Customer & Get ID
        // 2. Verify Customer & Get ID
        let customerSnapshot = await Customers.where('phoneNumber', '==', customerPhone).limit(1).get();

        if (customerSnapshot.empty) {
            // Fallback to check 'mobile' field if phoneNumber didn't match
            customerSnapshot = await Customers.where('mobile', '==', customerPhone).limit(1).get();
        }

        if (customerSnapshot.empty) return res.status(404).json({ error: 'Customer not found' });
        const customerDoc = customerSnapshot.docs[0];
        const customerId = customerDoc.id;

        // 3. Simple Availability Check (Basic collision detection)
        const existingSnapshot = await Bookings.where('cabinId', '==', cabinId)
            .where('date', '==', date)
            .where('startTime', '==', startTime)
            .where('status', '==', 'booked')
            .limit(1)
            .get();

        if (!existingSnapshot.empty) {
            return res.status(409).json({ error: 'Slot already booked' });
        }

        // 4. Create Booking
        const newBooking = {
            cabinId,
            customerId,
            customerId,
            customerPhone,
            mobile: customerPhone, // Redundancy for search compatibility
            date,
            startTime,
            minutes,
            ratePerMinute,
            totalAmount,
            status: 'booked',
            createdAt: new Date(),
            updatedAt: new Date()
        };

        const docRef = await Bookings.add(newBooking);

        res.status(201).json({ _id: docRef.id, ...newBooking });

    } catch (error) {
        console.error('Create Booking Error:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

// Get My Bookings
exports.getMyBookings = async (req, res) => {
    try {
        const { phoneNumber } = req.query;
        if (!phoneNumber) return res.status(400).json({ error: 'Phone number required' });

        // Fix: Use the same logic as createBooking or search by simplified phone field
        // Since bookings store 'customerPhone', we just matching that field directly?
        // Yes, existing logic matches `customerPhone` in bookings collection.
        // Assuming `customerPhone` in Booking is what client sends.

        // Remove orderBy to avoid 'Missing Index' error in Firestore
        const snapshot = await Bookings.where('customerPhone', '==', phoneNumber).get();

        // Sort in memory instead
        const docs = snapshot.docs;
        docs.sort((a, b) => {
            const dataA = a.data() || {};
            const dataB = b.data() || {};

            // Sort by date desc, then startTime desc
            const dateA = dataA.date || '';
            const dateB = dataB.date || '';

            if (dateA > dateB) return -1;
            if (dateA < dateB) return 1;

            const timeA = dataA.startTime || '';
            const timeB = dataB.startTime || '';
            return timeB.localeCompare(timeA);
        });

        // Emulate populate('cabinId') manually if needed. For now, just return cabinId.
        // To strictly match legacy behavior, we'd need to fetch each cabin.
        // Assuming client can fetch cabin details separately or we just return ID.
        // Let's do a simple fetch for cabins if needed or just return raw data for MVP speed as requested.

        const bookings = [];
        for (const doc of docs) {
            try {
                const data = doc.data();
                if (!data) continue; // Skip malformed docs

                let cabinData = { _id: "unknown", name: "Unknown Cabin", imageUrl: "" };

                // If data.cabinId is missing, try data.cabin object if it exists (legacy), or skip lookup
                const cabinId = data.cabinId;

                if (cabinId) {
                    try {
                        const cabinDoc = await Cabins.doc(cabinId).get();
                        if (cabinDoc.exists) {
                            cabinData = { _id: cabinDoc.id, ...cabinDoc.data() };
                        }
                    } catch (e) {
                        console.warn('Failed to populate cabin for booking', doc.id, e.message);
                    }
                } else if (data.cabin && typeof data.cabin === 'object') {
                    // Fallback if legacy cabin object is stored directly
                    cabinData = { _id: data.cabin._id || "legacy", ...data.cabin };
                }

                bookings.push({
                    _id: doc.id,
                    ...data,
                    cabinId: cabinData // Replace ID string with object to match populate()
                });
            } catch (err) {
                console.error("Skipping error booking doc:", doc.id, err);
            }
        }

        res.status(200).json(bookings);
    } catch (error) {
        console.error('Get My Bookings Error:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

