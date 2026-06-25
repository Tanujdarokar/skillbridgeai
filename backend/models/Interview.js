const mongoose = require('mongoose');

const InterviewSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  interviewType: {
    type: String,
    enum: ["HR", "Technical", "Behavioral"]
  },

  questions: [String],

  answers: [String],

  technicalScore: Number,

  communicationScore: Number,

  confidenceScore: Number,

  overallScore: Number,

  feedback: String

}, {
  timestamps: true
});

module.exports = mongoose.model('Interview', InterviewSchema);
