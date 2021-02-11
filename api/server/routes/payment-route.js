const express = require('express');

const router = express.Router();
const bodyParser = require('body-parser');
router.use(bodyParser.json());

router.post('/', (req, res) => {
    res.send("123");
});

module.exports = router;
