const express = require('express');
const router = express.Router();
const multer = require('multer');
const resumeController = require('../controllers/resumeController');
const auth = require('../middleware/auth');

const upload = multer({ dest: 'uploads/' });

router.post('/upload', auth, upload.single('resume'), resumeController.uploadResume);

module.exports = router;
