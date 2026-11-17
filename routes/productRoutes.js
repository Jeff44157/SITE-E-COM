const express = require('express');
const router = express.Router();
const db = require('../config/db');

// 1. Récupérer tous les produits (GET /api/products)
router.get('/', async (req, res) => {
  try {
    const [products] = await db.query('SELECT * FROM products');
    res.json(products);
  } catch (error) {
    console.error('Erreur GET /api/products :', error.message);
    res.status(500).json({ message: 'Erreur lors de la récupération des produits' });
  }
});

// 2. Récupérer un seul produit par son ID (GET /api/products/:id)
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM products WHERE id = ?', [req.params.id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Produit non trouvé' });
    }
    res.json(rows[0]);
  } catch (error) {
    console.error('Erreur GET /api/products/:id :', error.message);
    res.status(500).json({ message: 'Erreur serveur' });
  }
});

module.exports = router;