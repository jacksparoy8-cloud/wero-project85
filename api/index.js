const express = require('express');
const app = express();

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'WERO API Running on Vercel' });
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', environment: 'vercel' });
});

app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

module.exports = app;
