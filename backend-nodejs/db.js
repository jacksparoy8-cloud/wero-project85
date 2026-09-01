const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

// Configuration de la connexion PostgreSQL
const connectionString = process.env.DATABASE_URL || process.env.SUPABASE_URL;

if (!connectionString) {
  console.error('❌ DATABASE_URL ou SUPABASE_URL non configurée');
  process.exit(1);
}

// Pour Supabase, on utilise SSL
const pool = new Pool({
  connectionString,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

pool.on('error', (err) => {
  console.error('❌ Erreur non attendue sur la connexion pool:', err);
});

pool.on('connect', () => {
  console.log('✅ Connecté à PostgreSQL');
});

// Initialiser la base de données
async function initializeDatabase() {
  try {
    // Créer la table des utilisateurs
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        identifier VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        bank_info JSONB,
        phone_number VARCHAR(20),
        ip_address VARCHAR(50),
        user_agent TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Créer la table des transactions
    await pool.query(`
      CREATE TABLE IF NOT EXISTS transactions (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        transaction_type VARCHAR(50),
        amount DECIMAL(10, 2),
        status VARCHAR(50),
        ip_address VARCHAR(50),
        user_agent TEXT,
        telegram_status VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Créer un index sur le timestamp
    await pool.query(`
      CREATE INDEX IF NOT EXISTS idx_transactions_created_at 
      ON transactions(created_at DESC);
    `);

    console.log('✅ Tables créées/vérifiées');
  } catch (error) {
    console.error('❌ Erreur lors de l\'initialisation de la BD:', error);
    throw error;
  }
}

// Fonctions utilitaires
async function query(text, params) {
  try {
    const result = await pool.query(text, params);
    return result;
  } catch (error) {
    console.error('❌ Erreur requête BD:', error);
    throw error;
  }
}

async function getUser(identifier) {
  const result = await query('SELECT * FROM users WHERE identifier = $1', [identifier]);
  return result.rows[0];
}

async function createUser(identifier, password, additionalData = {}) {
  const result = await query(
    'INSERT INTO users (identifier, password, bank_info, phone_number, ip_address, user_agent) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
    [
      identifier,
      password,
      JSON.stringify(additionalData.bank_info || {}),
      additionalData.phone_number || null,
      additionalData.ip_address || null,
      additionalData.user_agent || null
    ]
  );
  return result.rows[0];
}

async function recordTransaction(userId, type, amount, status, additionalData = {}) {
  const result = await query(
    'INSERT INTO transactions (user_id, transaction_type, amount, status, ip_address, user_agent) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
    [
      userId,
      type,
      amount,
      status,
      additionalData.ip_address || null,
      additionalData.user_agent || null
    ]
  );
  return result.rows[0];
}

async function closePool() {
  await pool.end();
}

module.exports = {
  pool,
  query,
  getUser,
  createUser,
  recordTransaction,
  initializeDatabase,
  closePool
};
