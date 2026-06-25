const mongoose = require('mongoose');

const RoadmapSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  targetRole: String,

  roadmapTitle: String,

  milestones: [
    {
      title: String,
      description: String,
      status: {
        type: String,
        default: "pending"
      }
    }
  ],

  completionPercentage: {
    type: Number,
    default: 0
  }

}, {
  timestamps: true
});

module.exports = mongoose.model('Roadmap', RoadmapSchema);
