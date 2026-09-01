# Script de Setup - WERO + Cloudflare Tunnel (Windows)
# Usage: .\setup-cloudflare.ps1

Write-Host @"
╔════════════════════════════════════════════════════════╗
║   🚀 WERO - Setup Cloudflare Tunnel Deployment        ║
╚════════════════════════════════════════════════════════╝
"@
Write-Host ""

# Vérifier Docker
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker détecté: $dockerVersion"
} catch {
    Write-Host "❌ Docker n'est pas installé!"
    Write-Host "   Télécharge-le sur: https://www.docker.com/products/docker-desktop"
    exit 1
}

Write-Host ""

# Vérifier Cloudflare Token
$cfToken = $env:CLOUDFLARE_TOKEN
if (-not $cfToken) {
    Write-Host "📌 Étape 1: Token Cloudflare"
    Write-Host "   ❓ Obtiens ton token de tunnel:"
    Write-Host "      1. Va sur: https://dash.cloudflare.com/tunnels"
    Write-Host "      2. Crée un tunnel nommé 'wero'"
    Write-Host "      3. Copie le token complet"
    Write-Host ""
    $cfToken = Read-Host "   Paste ton CLOUDFLARE_TOKEN"
    
    if (-not $cfToken) {
        Write-Host "❌ Token requis!"
        exit 1
    }
}

# Vérifier Telegram
$tgToken = $env:TELEGRAM_BOT_TOKEN
$tgChatId = $env:TELEGRAM_CHAT_ID

if (-not $tgToken -or -not $tgChatId) {
    Write-Host "📌 Étape 2: Configuration Telegram"
    Write-Host "   ❓ Créé un bot Telegram:"
    Write-Host "      1. Ouvre @BotFather sur Telegram"
    Write-Host "      2. Crée un nouveau bot et copie le token"
    Write-Host "      3. Envoie un message au bot"
    Write-Host "      4. Va sur: https://api.telegram.org/bot{TOKEN}/getUpdates"
    Write-Host "      5. Récupère ton chat_id"
    Write-Host ""
    
    if (-not $tgToken) {
        $tgToken = Read-Host "   TELEGRAM_BOT_TOKEN"
    }
    
    if (-not $tgChatId) {
        $tgChatId = Read-Host "   TELEGRAM_CHAT_ID"
    }
}

# Créer .env.production
Write-Host ""
Write-Host "📝 Création de .env.production..."

$envContent = @"
NODE_ENV=production
PORT=3000
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=wero
DB_USERNAME=wero_user
DB_PASSWORD=secret

TELEGRAM_BOT_TOKEN=$tgToken
TELEGRAM_CHAT_ID=$tgChatId

CLOUDFLARE_TOKEN=$cfToken
"@

$envContent | Out-File -FilePath ".env.production" -Encoding UTF8

Write-Host "✅ .env.production créé"
Write-Host ""

# Build Docker Image
Write-Host "🔨 Construction de l'image Docker..."
docker compose build --no-cache nodejs

Write-Host ""
Write-Host "✅ Image Docker construite"
Write-Host ""

# Démarrer les services
Write-Host "🚀 Démarrage des services..."
docker compose --env-file .env.production up -d

Write-Host "✅ Services démarrés!"
Write-Host ""

# Attendre que l'app soit prête
Write-Host "⏳ Attente du démarrage de l'app..."
Start-Sleep -Seconds 5

# Vérifier la connexion
Write-Host ""
Write-Host "🔍 Vérification de l'app..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8002" -ErrorAction SilentlyContinue
    Write-Host "✅ App fonctionnelle sur http://localhost:8002"
} catch {
    Write-Host "⚠️  App pas encore prête, patiente quelques secondes..."
}

# Tester Telegram
Write-Host ""
Write-Host "📱 Test Telegram..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8002/api/test-telegram" -Method POST -ErrorAction SilentlyContinue
    Write-Host "✅ Telegram configuré"
} catch {
    Write-Host "⚠️  Erreur Telegram (vérifiez les logs)"
}

# Afficher les infos
Write-Host @"

╔════════════════════════════════════════════════════════╗
║               ✅ DÉPLOIEMENT COMPLÉTÉ                 ║
╚════════════════════════════════════════════════════════╝

📊 Informations:
   • App locale:     http://localhost:8002
   • Tunnel:         https://dash.cloudflare.com/tunnels
   • Logs:           docker compose logs nodejs -f

🔗 Ton app est maintenant publique!
   Vérifie le Dashboard Cloudflare pour l'URL publique

📝 Voir les logs:
   docker compose logs nodejs -f

🛑 Arrêter:
   docker compose down

"@
