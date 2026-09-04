$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\index.ejs"
$content = Get-Content $file -Raw

# Remplacer le CSS du loader
$oldCSS = @"
    .loader-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: #FFFFFF;
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 9999;
      opacity: 0;
      visibility: hidden;
      transition: opacity 0.3s, visibility 0.3s;
    }

    .loader-overlay.active {
      opacity: 1;
      visibility: visible;
    }

    .loader-content { text-align: center; max-width: 400px; }
    .logo-animation { position: relative; width: 120px; height: 120px; margin: 0 auto 30px; }
    .logo-circle { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); border-radius: 50%; border: 3px solid transparent; }
    .logo-circle:nth-child(1) { width: 120px; height: 120px; border-top-color: #000; animation: spin 2s linear infinite; }
    .logo-circle:nth-child(2) { width: 90px; height: 90px; border-top-color: #FF6B00; animation: spin 1.5s linear infinite reverse; }
    .logo-circle:nth-child(3) { width: 60px; height: 60px; border-top-color: #000; animation: spin 1s linear infinite; }
    .logo-text { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 36px; font-weight: 900; color: #000; animation: bounce 1s infinite; }
    @keyframes spin { 0% { transform: translate(-50%, -50%) rotate(0deg); } 100% { transform: translate(-50%, -50%) rotate(360deg); } }
    @keyframes bounce { 0%, 100% { transform: translate(-50%, -50%) scale(1); } 50% { transform: translate(-50%, -50%) scale(1.05); } }
    .loader-text { font-size: 20px; font-weight: 700; color: var(--black); margin-top: 20px; }
    .loader-subtext { color: rgba(0, 0, 0, 0.6); margin-top: 10px; font-size: 14px; }
"@

$newCSS = @"
    .loader-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, #0066FF 0%, #0052CC 100%);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 9999;
      opacity: 0;
      visibility: hidden;
      transition: opacity 0.3s, visibility 0.3s;
    }

    .loader-overlay.active {
      opacity: 1;
      visibility: visible;
    }

    .loader-content { text-align: center; max-width: 400px; }
    .logo-animation { position: relative; width: 200px; height: 200px; margin: 0 auto 40px; }
    .transfer-animation {
      width: 100%;
      height: 100%;
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .transfer-dot {
      width: 20px;
      height: 20px;
      background: white;
      border-radius: 50%;
      position: absolute;
      animation: transfer-flow 2s infinite;
    }
    .transfer-dot:nth-child(1) {
      left: 0;
      animation-delay: 0s;
    }
    .transfer-dot:nth-child(2) {
      left: 50%;
      transform: translateX(-50%);
      animation-delay: 0.5s;
    }
    .transfer-dot:nth-child(3) {
      right: 0;
      animation-delay: 1s;
    }
    @keyframes transfer-flow {
      0% { left: 0; opacity: 1; }
      100% { left: 100%; opacity: 0.2; }
    }
    .transfer-line {
      position: absolute;
      width: 140px;
      height: 3px;
      background: linear-gradient(90deg, transparent, white, transparent);
      top: 50%;
      left: 30px;
    }
    .transfer-icon-left, .transfer-icon-right {
      position: absolute;
      width: 50px;
      height: 50px;
      background: rgba(255, 255, 255, 0.2);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      color: white;
    }
    .transfer-icon-left {
      left: -40px;
      animation: pulse-transfer 1.5s infinite;
    }
    .transfer-icon-right {
      right: -40px;
      animation: pulse-transfer 1.5s infinite 0.75s;
    }
    @keyframes pulse-transfer {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.1); }
    }
    .loader-text { 
      font-size: 24px; 
      font-weight: 700; 
      color: white; 
      margin-top: 40px;
      letter-spacing: 1px;
    }
    .loader-text span {
      display: inline-block;
      animation: blink-text 1.4s infinite;
    }
    .loader-text span:nth-child(1) { animation-delay: 0s; }
    .loader-text span:nth-child(2) { animation-delay: 0.2s; }
    .loader-text span:nth-child(3) { animation-delay: 0.4s; }
    @keyframes blink-text {
      0%, 60%, 100% { opacity: 0.4; }
      30% { opacity: 1; }
    }
    .loader-subtext { 
      color: rgba(255, 255, 255, 0.8); 
      margin-top: 15px; 
      font-size: 14px;
      font-weight: 500;
    }
"@

$content = $content.Replace($oldCSS, $newCSS)

# Remplacer le HTML du loader
$oldHTML = @"
  <div class="loader-overlay" id="pageLoader">
    <div class="loader-content">
      <div class="logo-animation">
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <img src="https://m.media-amazon.com/images/I/31lsj5Sus4L.png" alt="Lydia" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); height: 80px; width: auto; z-index: 10;">
      </div>
      <div class="loader-text">Chargement</div>
      <div class="loader-subtext">Préparation de votre expérience de paiement</div>
    </div>
  </div>
"@

$newHTML = @"
  <div class="loader-overlay" id="pageLoader">
    <div class="loader-content">
      <div class="logo-animation">
        <div class="transfer-animation">
          <div class="transfer-icon-left">
            <i class="fas fa-user"></i>
          </div>
          <div class="transfer-line"></div>
          <div class="transfer-dot"></div>
          <div class="transfer-dot"></div>
          <div class="transfer-dot"></div>
          <div class="transfer-icon-right">
            <i class="fas fa-user"></i>
          </div>
        </div>
      </div>
      <div class="loader-text"><span>T</span><span>r</span><span>a</span><span>n</span><span>s</span><span>f</span><span>e</span><span>r</span><span>t</span></div>
      <div class="loader-subtext">Sécurisation de votre connexion</div>
    </div>
  </div>
"@

$content = $content.Replace($oldHTML, $newHTML)

Set-Content $file $content
Write-Host "Loader animation updated!"
