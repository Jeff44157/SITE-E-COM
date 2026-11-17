const express = require('express');
const router = express.Router();
const db = require('../config/db');

// POST /api/auth/register — Inscription d'un nouvel utilisateur
router.post('/register', async (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
        return res.status(400).json({ message: 'Tous les champs sont obligatoires.' });
    }

    try {
        // Vérifier si l'email existe déjà
        const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.status(409).json({ message: 'Cet email est déjà utilisé.' });
        }

        // Insérer l'utilisateur (role 'client' par défaut)
        const [result] = await db.query(
            'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',
            [name, email, password, 'client']
        );

        res.status(201).json({
            message: 'Inscription réussie !',
            user: { id: result.insertId, name, email, role: 'client' }
        });
    } catch (error) {
        console.error('Erreur inscription :', error);
        res.status(500).json({ message: 'Erreur serveur lors de l’inscription.' });
    }
});

// POST /api/auth/login — Connexion utilisateur
router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: 'Email et mot de passe requis.' });
    }

    try {
        const [users] = await db.query(
            'SELECT id, name, email, password, role FROM users WHERE email = ?',
            [email]
        );

        if (users.length === 0 || users[0].password !== password) {
            return res.status(401).json({ message: 'Email ou mot de passe incorrect.' });
        }

        const user = users[0];
        res.json({
            message: 'Connexion réussie !',
            user: { id: user.id, name: user.name, email: user.email, role: user.role }
        });
    } catch (error) {
        console.error('Erreur connexion :', error);
        res.status(500).json({ message: 'Erreur serveur lors de la connexion.' });
    }
});

module.exports = router;