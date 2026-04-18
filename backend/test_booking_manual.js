const { createBooking, getMyBookings } = require('./src/modules/bookings/booking.controller');
const { admin } = require('./src/config/firebase');

// Mock Req/Res
const mockRes = () => {
    const res = {};
    res.status = (code) => {
        res.statusCode = code;
        return res;
    };
    res.json = (data) => {
        res.data = data;
        return res;
    };
    return res;
};

async function testBooking() {
    console.log('--- Testing Booking Controller ---');

    // 1. Test Get Bookings
    console.log('\n1. Testing getMyBookings...');
    const reqGet = { query: { phoneNumber: '+923172208626' } }; // Use phone from screenshot
    const resGet = mockRes();

    try {
        await getMyBookings(reqGet, resGet);
        console.log('Get Result Status:', resGet.statusCode);
        if (resGet.statusCode === 200) {
            console.log('Bookings found:', resGet.data.length);
        } else {
            console.log('Get Error:', resGet.data);
        }
    } catch (e) {
        console.error('CRASH in getMyBookings:', e);
    }

    // 2. Test Create Booking (Basic validation only to hit controller logic)
    console.log('\n2. Testing createBooking...');
    const reqCreate = {
        body: {
            customerPhone: '+923172208626',
            cabinId: 'test_cabin_id',
            date: '2025-01-20',
            startTime: '10:00',
            minutes: 20,
            ratePerMinute: 2.0,
            totalAmount: 40.0
        }
    };
    const resCreate = mockRes();

    try {
        await createBooking(reqCreate, resCreate);
        console.log('Create Result Status:', resCreate.statusCode);
        console.log('Create Response:', resCreate.data);
    } catch (e) {
        console.error('CRASH in createBooking:', e);
    }
}

testBooking();
