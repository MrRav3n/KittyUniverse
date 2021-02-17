// import dependencies and initialize express
const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');

const swaggerRoutes = require('./routes/swagger-route');
const paymentRoutes = require('./routes/payment-route');

const app = express();

// enable parsing of http request body
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use('/swagger', swaggerRoutes);
app.use('/payment', paymentRoutes);
app.get('/', (req, res) => {
  
  res.send({version: "1.0"})
})

// start node server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`App UI available http://localhost:${port}`);
  console.log(`Swagger UI available http://localhost:${port}/swagger/api-docs`);
});



module.exports = app;
