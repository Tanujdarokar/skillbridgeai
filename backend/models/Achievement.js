const mongoose = require('mongoose');

const AchievementSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  badgeName: String,

  description: String,

  earnedAt: Date

}, {
  timestamps: true
});

module.exports = mongoose.model('Achievement', AchievementSchema);
