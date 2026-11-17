const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const productRoutes = require('./routes/productRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// Servir automatiquement les fichiers du dossier Frontend (public/)
app.use(express.static(path.join(__dirname, 'public')));

// Routes API
app.use('/api/products', productRoutes);

// Route de test rapide pour vérifier que l'API répond
app.get('/api/status', (req, res) => {
  res.json({ status: 'OK', message: 'Serveur e-commerce opérationnel !' });
});

// Démarrage du serveur
app.listen(PORT, () => {
  console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
});