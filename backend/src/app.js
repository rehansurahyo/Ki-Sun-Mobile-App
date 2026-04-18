require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { swaggerUi, swaggerDocument } = require('./config/swagger');
const { db } = require('./config/firebase'); // Initialize Firebase

const app = express();

// Middleware
app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));

// Database Connection
// Firebase is initialized in ./config/firebase.js

// Routes
const userRoutes = require('./modules/users/user.routes');
const authRoutes = require('./modules/auth/auth.routes');
const kycRoutes = require('./modules/kyc/kyc.routes');
const consentRoutes = require('./modules/consent/consent.routes');
const skinAnalysisRoutes = require('./modules/skin-analysis/skin-analysis.routes');
const membershipRoutes = require('./modules/membership/membership.routes');
const customerRoutes = require('./modules/customers/customer.routes');
const cabinRoutes = require('./modules/cabins/cabin.routes');
const bookingRoutes = require('./modules/bookings/booking.routes');

app.use('/api/users', userRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/kyc', kycRoutes);
app.use('/api/consent', consentRoutes);
app.use('/api/skin-analysis', skinAnalysisRoutes);
app.use('/api/membership', membershipRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/cabins', cabinRoutes);
app.use('/api/bookings', bookingRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Ki-Sun API ☀️ (Firebase Edition)' });
});

// Swagger
app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Error Handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

const PORT = process.env.PORT || 3000;
if (process.env.NODE_ENV !== 'production') {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
  });
}

module.exports = app;
