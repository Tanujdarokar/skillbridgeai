const mongoose = require('mongoose');

const CourseSchema = new mongoose.Schema({
  title: String,

  provider: String,

  description: String,

  duration: String,

  skillsCovered: [String],

  courseUrl: String,

  level: String

}, {
  timestamps: true
});

module.exports = mongoose.model('Course', CourseSchema);
