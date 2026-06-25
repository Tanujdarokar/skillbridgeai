const mongoose = require('mongoose');

const ChatSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  question: String,

  answer: String,

  aiModel: String

}, {
  timestamps: true
});

module.exports = mongoose.model('Chat', ChatSchema);
