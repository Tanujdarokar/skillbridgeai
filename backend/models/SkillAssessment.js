const mongoose = require('mongoose');

const SkillAssessmentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  targetRole: String,

  obtainedScore: Number,

  totalScore: Number,

  skillMatchPercentage: Number,

  strengths: [String],

  missingSkills: [String]

}, {
  timestamps: true
});

module.exports = mongoose.model('SkillAssessment', SkillAssessmentSchema);
