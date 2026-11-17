const express = require('express');
const router = express.Router();
const db = require('../config/db');

// POST /api/orders — Créer une nouvelle commande depuis le panier
router.post('/', async (req, res) => {
    const { user_id, total_price } = req.body;

    if (!user_id || total_price === undefined) {
        return res.status(400).json({ message: 'user_id et total_price sont requis.' });
    }

    try {
        const [result] = await db.query(
            'INSERT INTO orders (user_id, total_price, status) VALUES (?, ?, ?)',
            [user_id, total_price, 'en_attente']
        );

        res.status(201).json({
            message: 'Commande enregistrée avec succès !',
            orderId: result.insertId
        });
    } catch (error) {
        console.error('Erreur création commande :', error);
        res.status(500).json({ message: 'Erreur serveur lors de la commande.' });
    }
});

// GET /api/orders/user/:userId — Récupérer l'historique des commandes d'un client
router.get('/user/:userId', async (req, res) => {
    try {
        const [orders] = await db.query(
            'SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC',
            [req.params.userId]
        );
        res.json(orders);
    } catch (error) {
        console.error('Erreur récupération commandes :', error);
        res.status(500).json({ message: 'Erreur serveur.' });
    }
});

module.exports = router;