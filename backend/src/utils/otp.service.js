// In-memory store for dev (Use Redis in production)
const otpStore = new Map();

class OtpService {

    static generateOtp(identifier) {
        const code = Math.floor(100000 + Math.random() * 900000).toString();
        // Expires in 5 minutes
        const expires = Date.now() + 5 * 60 * 1000;

        otpStore.set(identifier, { code, expires });

        // In Production: Call SMS/Email Provider
        console.log(`🔐 OTP for ${identifier}: ${code}`);

        return code;
    }

    static verifyOtp(identifier, code) {
        const record = otpStore.get(identifier);
        if (!record) return false;

        if (Date.now() > record.expires) {
            otpStore.delete(identifier);
            return false;
        }

        if (record.code === code) {
            otpStore.delete(identifier); // One-time use
            return true;
        }

        return false;
    }
}

module.exports = OtpService;
