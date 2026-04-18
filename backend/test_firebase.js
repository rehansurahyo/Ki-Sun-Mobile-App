const { admin, db } = require('./src/config/firebase');

async function testConnection() {
    console.log('Testing Firebase Connection...');
    try {
        const collections = await db.listCollections();
        console.log('Connected! Collections found:', collections.map(c => c.id));
    } catch (error) {
        console.error('Connection Failed:', error);
    }
}

testConnection();
