const db = require('../controllers/dbConnection');
const Payment = require("../models/payment");

const create = (req, res) => {
    if (!req.body) {
        res.status(400).send({
            message: "Content can not be empty!"
        })
    }
    
    const paymentObj = new Payment({
        userId: req.body.userId,
        tokensAmount: req.body.tokensAmount,
        animalAction: req.body.animalAction,
        duration: req.body.duration,
    })
    
    db.query("INSERT INTO payment SET ?", paymentObj, (err, data) => {
        if (err) {
            res.status(500);
            res.send({message: err.message ||
                    "Some error occurred while creating the Customer."
            });
        }
        res.send({ id: data.insertId, ...paymentObj });
    });
}

module.exports.create = create;