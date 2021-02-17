// import dependencies and initialize express
const { contractAbi, contractAddress } = require('../../config/nodejsContractConfig');
const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');

const swaggerRoutes = require('./routes/swagger-route');
const Web3 = require("web3");

const app = express();
let web3 = new Web3("wss://kovan.infura.io/ws/v3/9a90d396c48646c89c0eade717fe8f96");
const getContract = () => {
  return new web3.eth.Contract(contractAbi, contractAddress);
};
const contract = getContract();
contract.events.AdoptEvent({ fromBlock:'latest' }, function(error, result) {
  console.log(result);
  console.log(error);
});
// enable parsing of http request body
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use('/swagger', swaggerRoutes);
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
