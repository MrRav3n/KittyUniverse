const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');
const payment  = require('../controllers/paymentController')
router.use(bodyParser.json());

router.post('/', payment.create)

module.exports = router;
