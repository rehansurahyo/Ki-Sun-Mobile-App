const mongoose = require('mongoose');
require('dotenv').config();

const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/ki_sun_db';

async function dropIndex() {
    try {
        await mongoose.connect(MONGO_URI);
        console.log('✅ Connected to MongoDB');

        const collection = mongoose.connection.collection('customers');

        // List indexes to verify
        const indexes = await collection.indexes();
        console.log('🔍 Current Indexes:', indexes);

        // Drop the problematic index
        // The error log named it 'personNumber_1'
        if (indexes.find(idx => idx.name === 'personNumber_1')) {
            await collection.dropIndex('personNumber_1');
            console.log('🗑️ Dropped index: personNumber_1');
        } else {
            console.log('ℹ️ Index personNumber_1 not found.');
        }

    } catch (error) {
        console.error('❌ Error:', error.message);
    } finally {
        await mongoose.disconnect();
        console.log('👋 Disconnected');
    }
}

dropIndex();
