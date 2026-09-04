# Railway Deployment Guide - Lydia Payment App

## Étapes de déploiement sur Railway

### 1. **Créer un compte Railway**
   - Va sur https://railway.app
   - Inscription avec GitHub ou email
   - Crédits gratuits: $5/mois

### 2. **Connecter ton GitHub**
   - Settings → GitHub OAuth
   - Autorise Railway à accéder à tes repos

### 3. **Créer un nouveau projet**
   - Click "New Project"
   - "Deploy from GitHub"
   - Sélectionne: `nuitfalla`
   - Branch: `main`

### 4. **Ajouter PostgreSQL**
   - Click "Add Service" → "PostgreSQL"
   - Railway crée la DB automatiquement
   - Variables d'env sont auto-générées

### 5. **Configurer les variables d'environnement**
   Dans Railway Dashboard → Variables:
   ```
   NODE_ENV=production
   PORT=3000
   TELEGRAM_BOT_TOKEN=<ton_token_bot>
   TELEGRAM_CHAT_ID=<ton_chat_id>
   DATABASE_URL=<auto-généré par PostgreSQL>
   ```

### 6. **Deploy**
   - Railway déploie automatiquement à chaque push GitHub
   - L'app sera accessible sur: `https://nuitfalla-production.up.railway.app`

### 7. **Monitoring**
   - Dashboard → Logs pour voir les erreurs
   - Click app → Metrics pour CPU/Mémoire

## Avantages Railway vs Vercel
- ✅ PostgreSQL inclus gratuit
- ✅ Déploiements illimités
- ✅ $5 crédit gratuit (suffit 2-3 mois)
- ✅ Support Node.js optimal
- ✅ Domaine personnalisé possible

## Coûts après crédit gratuit
- App Node.js: ~$5-10/mois
- PostgreSQL: ~$5-15/mois
- **Total: ~$10-25/mois**
