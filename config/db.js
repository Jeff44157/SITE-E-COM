const mysql = require('mysql2');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10
});

// Test de connexion immédiat
pool.getConnection((err, connection) => {
  if (err) {
    console.error('❌ Erreur de connexion MySQL :', err.message);
  } else {
    console.log('✅ Connecté à la base de données MySQL (ecommerce_db) !');
    connection.release();
  }
});

module.exports = pool.promise();