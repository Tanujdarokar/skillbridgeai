const User = require('../models/User');

exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const { fullName, phone, location, education, skills, careerGoal, preferredLanguage } = req.body;

    const user = await User.findByIdAndUpdate(
      req.user.id,
      {
        $set: {
          fullName,
          phone,
          location,
          education,
          skills,
          careerGoal,
          preferredLanguage
        }
      },
      { new: true }
    ).select('-password');

    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
