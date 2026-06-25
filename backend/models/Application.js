const mongoose = require('mongoose');

const ApplicationSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },

  jobId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Job"
  },

  status: {
    type: String,
    enum: [
      "Applied",
      "Shortlisted",
      "Interview",
      "Rejected",
      "Selected"
    ],
    default: "Applied"
  }

}, {
  timestamps: true
});

module.exports = mongoose.model('Application', ApplicationSchema);
