const mysql = require('mysql');
const dbConfig = require('../config/dbConfig');

const connection = mysql.createConnection({...dbConfig});

connection.connect((error) => {
    if (error) throw error;
    console.log('Succesfully connected to the database');
})

module.exports = connection;