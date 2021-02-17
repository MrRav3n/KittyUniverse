const Payment = function(payment) {
    this.userId = payment.userId;
    this.tokensAmount = payment.tokensAmount;
    this.animalAction = payment.animalAction;
    this.duration = payment.duration || null;
    this.completed = payment.completed || false
}

module.exports = Payment;