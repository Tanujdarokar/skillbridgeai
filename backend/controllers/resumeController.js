const fs = require('fs');
const axios = require('axios');
const FormData = require('form-data');

exports.uploadResume = async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ message: 'No file uploaded' });

    const formData = new FormData();
    formData.append('file', fs.createReadStream(req.file.path));
    formData.append('target_role', req.body.target_role || 'Software Engineer');

    const response = await axios.post('http://localhost:8000/analyze-resume', formData, {
      headers: {
        ...formData.getHeaders(),
      },
    });

    // Clean up uploaded file
    fs.unlinkSync(req.file.path);

    res.json(response.data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Error analyzing resume', error: err.message });
  }
};
