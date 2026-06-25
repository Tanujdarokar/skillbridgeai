const mongoose = require('mongoose');

const JobSchema = new mongoose.Schema({
  title: String,

  companyName: String,

  location: String,

  description: String,

  requiredSkills: [String],

  experienceRequired: String,

  salaryRange: String,

  applicationUrl: String

}, {
  timestamps: true
});

module.exports = mongoose.model('Job', JobSchema);
