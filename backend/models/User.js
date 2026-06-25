const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true
  },

  email: {
    type: String,
    required: true,
    unique: true
  },

  phone: String,

  password: String,

  googleId: String,

  profileImage: String,

  role: {
    type: String,
    enum: ["student", "admin"],
    default: "student"
  },

  education: {
    degree: String,
    branch: String,
    college: String,
    graduationYear: Number
  },

  careerGoal: String,

  skills: [String],

  preferredLanguage: {
    type: String,
    default: "English"
  },

  location: String,

  isVerified: {
    type: Boolean,
    default: false
  }

}, {
  timestamps: true
});

module.exports = mongoose.model('User', UserSchema);
