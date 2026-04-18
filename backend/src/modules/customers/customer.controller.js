const Customers = require('./customer.model');

// Create or Update Customer
// Create or Update Customer
exports.createOrUpdateCustomer = async (req, res) => {
    // console.log("➡️ Received Customer Data:", JSON.stringify(req.body, null, 2));
    try {
        const {
            phoneNumber, mobile, isPhoneVerified, consents,
            salutation, title, firstName, lastName, birthDate,
            personNumber, skinType, profileImage,
            address, communication, comment
        } = req.body;

        const phoneToUse = phoneNumber || mobile;

        if (!phoneToUse) {
            return res.status(400).json({ error: 'Phone number is required' });
        }

        // Check if customer exists by phoneNumber or mobile
        let snapshot = await Customers.where('mobile', '==', phoneToUse).limit(1).get();
        if (snapshot.empty) {
            snapshot = await Customers.where('phoneNumber', '==', phoneToUse).limit(1).get();
        }

        let resultDoc;

        if (!snapshot.empty) {
            // --- UPDATE (PATCH) ---
            const docId = snapshot.docs[0].id;
            const updates = {};

            // Only add fields if they are explicitly provided (not undefined)
            if (phoneNumber) updates.phoneNumber = phoneToUse;
            if (mobile) updates.mobile = phoneToUse;
            if (phoneToUse) updates.phone = phoneToUse;
            if (isPhoneVerified !== undefined) updates.isPhoneVerified = isPhoneVerified;
            if (salutation !== undefined) updates.salutation = salutation;
            if (title !== undefined) updates.title = title;
            if (firstName !== undefined) updates.firstName = firstName;
            if (lastName !== undefined) updates.lastName = lastName;
            if (birthDate !== undefined) updates.birthDate = new Date(birthDate);
            if (personNumber !== undefined) updates.personNumber = personNumber;
            if (profileImage !== undefined) updates.profileImage = profileImage;
            if (skinType !== undefined) updates.skinType = skinType;
            if (address !== undefined) updates.address = address;
            if (communication !== undefined) updates.communication = communication;
            if (comment !== undefined) updates.comment = comment;

            // Consents merge is tricky. If provided, merge with existing? 
            // For now, if 'consents' obj is provided, assume it's a merge or replacement of flags.
            if (consents) {
                // We'll use dot notation in a real app, but here let's just merge what we have
                // To avoid reading first, we can assume client sends full consent or we do a simple merge if we fetched existing...
                // But we haven't fetched 'existing' data yet, just snapshot.
                // Let's rely on client to send what changed or valid flags.
                // However, previous code defaulted false. 
                // Let's just update specific fields if provided in consents
                const map = {
                    'consents.privacy_policy': consents.privacy_policy,
                    'consents.terms_of_service': consents.terms_of_service,
                    'consents.studio_rules': consents.studio_rules,
                    'consents.marketing_opt_in': consents.marketing_opt_in,
                    'consents.accepted_at': new Date()
                };

                Object.keys(map).forEach(k => {
                    if (map[k] !== undefined) updates[k] = map[k];
                });
            }

            updates.updatedAt = new Date();

            await Customers.doc(docId).update(updates);
            const updatedDoc = await Customers.doc(docId).get();
            resultDoc = { _id: updatedDoc.id, ...updatedDoc.data() };

        } else {
            // --- CREATE (New User) ---
            const customerData = {
                phoneNumber: phoneToUse,
                mobile: phoneToUse,
                phone: phoneToUse,
                isPhoneVerified: isPhoneVerified ?? true,
                salutation: salutation || "",
                title: title || "",
                firstName: firstName || "",
                lastName: lastName || "",
                birthDate: birthDate ? new Date(birthDate) : null,
                personNumber: personNumber || null,
                profileImage: profileImage || "",
                skinType: skinType || "",
                address: address || {},
                communication: communication || {},
                comment: comment || "",
                consents: {
                    privacy_policy: consents?.privacy_policy ?? false,
                    terms_of_service: consents?.terms_of_service ?? false,
                    studio_rules: consents?.studio_rules ?? false,
                    marketing_opt_in: consents?.marketing_opt_in ?? false,
                    accepted_at: new Date()
                },
                updatedAt: new Date(),
                createdAt: new Date(),
                visits: 0,
                tag: "New",
                walletBalance: 0
            };

            const docRef = await Customers.add(customerData);
            const newDoc = await docRef.get();
            resultDoc = { _id: newDoc.id, ...newDoc.data() };
        }

        res.status(200).json({
            message: 'Customer data saved successfully',
            customer: resultDoc
        });
    } catch (error) {
        console.error('Error saving customer:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

// Get All Customers (Verification) or Get by Phone
exports.getAllCustomers = async (req, res) => {
    try {
        const { phoneNumber, mobile } = req.query;
        const phoneParam = phoneNumber || mobile;

        let query = Customers;

        if (phoneParam) {
            // Try searching 'mobile' field first, or 'phoneNumber'
            query = query.where('mobile', '==', phoneParam);
        } else {
            query = query.orderBy('updatedAt', 'desc');
        }

        let snapshot = await query.get();

        // Fallback: if empty and looking for valid phone param, try 'phoneNumber' field
        if (snapshot.empty && phoneParam) {
            const fallbackQuery = Customers.where('phoneNumber', '==', phoneParam);
            snapshot = await fallbackQuery.get();
        }

        const customers = snapshot.docs.map(doc => ({
            _id: doc.id,
            ...doc.data()
        }));

        res.status(200).json(customers);
    } catch (error) {
        console.error('Error fetching customers:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
