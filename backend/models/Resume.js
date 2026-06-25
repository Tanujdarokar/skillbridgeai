const mongoose = require('mongoose');

const ResumeSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  resumeUrl: String,

  atsScore: Number,

  extractedSkills: [String],

  missingKeywords: [String],

  strengths: [String],

  improvements: [String],

  analyzedAt: Date

}, {
  timestamps: true
});

module.exports = mongoose.model('Resume', ResumeSchema);
