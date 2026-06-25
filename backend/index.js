const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const compression = require('compression');
const helmet = require('helmet');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const resumeRoutes = require('./routes/resume');
const chatRoutes = require('./routes/chat');

const app = express();

// Middleware for performance and security
app.use(helmet()); // Security headers
app.use(compression()); // Gzip compression
app.use(cors());
app.use(express.json({ limit: '10mb' })); // Limit body size for scalability

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/resume', resumeRoutes);
app.use('/api/chat', chatRoutes);

// Root endpoint
app.get('/', (req, res) => {
  res.send('SkillBridge AI API is running...');
});

// Database Connection & Seeding
const User = require('./models/User');
const bcrypt = require('bcryptjs');

mongoose.connect(process.env.MONGO_URI)
  .then(async () => {
    console.log('Connected to MongoDB');

    // Seed Test User if not exists
    const testEmail = 'test@skillbridge.ai';
    const testUser = await User.findOne({ email: testEmail });
    if (!testUser) {
      const hashedPassword = await bcrypt.hash('password123', 10);
      await User.create({
        fullName: 'Test Student',
        email: testEmail,
        password: hashedPassword,
        role: 'student',
        isVerified: true
      });
      console.log('Test user created: test@skillbridge.ai / password123');
    }
  })
  .catch((err) => console.error('MongoDB connection error:', err));

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!', error: err.message });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
