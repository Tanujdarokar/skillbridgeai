const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const auth = require('../middleware/auth');

router.post('/message', auth, chatController.sendMessage);

module.exports = router;
