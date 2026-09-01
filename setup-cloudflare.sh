#!/bin/bash

# Script de Setup - WERO + Cloudflare Tunnel
# Usage: ./setup-cloudflare.sh

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║   🚀 WERO - Setup Cloudflare Tunnel Deployment        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Vérifier Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé!"
    echo "   Télécharge-le sur: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "✅ Docker détecté: $(docker --version)"
echo ""

# Vérifier Cloudflare Token
if [ -z "$CLOUDFLARE_TOKEN" ]; then
    echo "📌 Étape 1: Token Cloudflare"
    echo "   ❓ Obtiens ton token de tunnel:"
    echo "      1. Va sur: https://dash.cloudflare.com/tunnels"
    echo "      2. Crée un tunnel nommé 'wero'"
    echo "      3. Copie le token complet"
    echo ""
    read -p "   Paste ton CLOUDFLARE_TOKEN: " CLOUDFLARE_TOKEN
    
    if [ -z "$CLOUDFLARE_TOKEN" ]; then
        echo "❌ Token requis!"
        exit 1
    fi
fi

# Vérifier Telegram
if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "📌 Étape 2: Configuration Telegram"
    echo "   ❓ Créé un bot Telegram:"
    echo "      1. Ouvre @BotFather sur Telegram"
    echo "      2. Crée un nouveau bot et copie le token"
    echo "      3. Envoie un message au bot"
    echo "      4. Va sur: https://api.telegram.org/bot{TOKEN}/getUpdates"
    echo "      5. Récupère ton chat_id"
    echo ""
    
    if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
        read -p "   TELEGRAM_BOT_TOKEN: " TELEGRAM_BOT_TOKEN
    fi
    
    if [ -z "$TELEGRAM_CHAT_ID" ]; then
        read -p "   TELEGRAM_CHAT_ID: " TELEGRAM_CHAT_ID
    fi
fi

# Créer .env.production
echo ""
echo "📝 Création de .env.production..."
cat > .env.production << EOF
NODE_ENV=production
PORT=3000
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=wero
DB_USERNAME=wero_user
DB_PASSWORD=secret

TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}

CLOUDFLARE_TOKEN=${CLOUDFLARE_TOKEN}
EOF

echo "✅ .env.production créé"
echo ""

# Build Docker Image
echo "🔨 Construction de l'image Docker..."
docker compose build --no-cache nodejs

echo ""
echo "✅ Image Docker construite"
echo ""

# Démarrer les services
echo "🚀 Démarrage des services..."
docker compose --env-file .env.production up -d

echo "✅ Services démarrés!"
echo ""

# Attendre que l'app soit prête
echo "⏳ Attente du démarrage de l'app..."
sleep 5

# Vérifier la connexion
echo ""
echo "🔍 Vérification de l'app..."
if curl -s http://localhost:8002 > /dev/null; then
    echo "✅ App fonctionnelle sur http://localhost:8002"
else
    echo "⚠️  App pas encore prête, patiente quelques secondes..."
fi

# Tester Telegram
echo ""
echo "📱 Test Telegram..."
curl -s -X POST http://localhost:8002/api/test-telegram > /dev/null && \
    echo "✅ Telegram configuré" || \
    echo "⚠️  Erreur Telegram (vérifiez les logs)"

# Afficher les infos
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║               ✅ DÉPLOIEMENT COMPLÉTÉ                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Informations:"
echo "   • App locale:     http://localhost:8002"
echo "   • Tunnel:         https://dash.cloudflare.com/tunnels"
echo "   • Logs:           docker compose logs nodejs -f"
echo ""
echo "🔗 Ton app est maintenant publique!"
echo "   Vérifie le Dashboard Cloudflare pour l'URL publique"
echo ""
echo "📝 Voir les logs:"
echo "   docker compose logs nodejs -f"
echo ""
echo "🛑 Arrêter:"
echo "   docker compose down"
echo ""
