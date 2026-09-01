$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\index.ejs"
$content = Get-Content $file -Raw

# Remplacer le CSS du loader
$oldCSS = @"
    .loader-content { text-align: center; max-width: 400px; }
    .logo-animation { position: relative; width: 120px; height: 120px; margin: 0 auto 30px; }
    .logo-circle { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); border-radius: 50%; border: 3px solid transparent; }
    .logo-circle:nth-child(1) { width: 120px; height: 120px; border-top-color: var(--blue); animation: spin 2s linear infinite; }
    .logo-circle:nth-child(2) { width: 90px; height: 90px; border-top-color: #0052CC; animation: spin 1.5s linear infinite reverse; }
    .logo-circle:nth-child(3) { width: 60px; height: 60px; border-top-color: var(--blue); animation: spin 1s linear infinite; }
    .logo-text { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 36px; font-weight: 900; color: var(--blue); animation: bounce 1s infinite; }
    @keyframes spin { 0% { transform: translate(-50%, -50%) rotate(0deg); } 100% { transform: translate(-50%, -50%) rotate(360deg); } }
    @keyframes bounce { 0%, 100% { transform: translate(-50%, -50%) scale(1); } 50% { transform: translate(-50%, -50%) scale(1.05); } }
    .loader-text { font-size: 20px; font-weight: 700; color: var(--black); margin-top: 20px; }
    .loader-subtext { color: rgba(0, 0, 0, 0.6); margin-top: 10px; font-size: 14px; }
"@

$newCSS = @"
    .loader-content { text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    .logo-animation { position: relative; width: 180px; height: 180px; margin: 0 auto 30px; display: flex; align-items: center; justify-content: center; }
    .logo-animation img { animation: logoZoom 1.5s cubic-bezier(0.34, 1.56, 0.64, 1) infinite; max-width: 100%; height: auto; }
    .logo-circle { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); border-radius: 50%; border: 3px solid transparent; }
    .logo-circle:nth-child(2) { width: 180px; height: 180px; border: 3px solid rgba(0, 102, 255, 0.3); animation: pulse-ring 2s ease-out infinite; }
    .logo-circle:nth-child(3) { width: 200px; height: 200px; border: 2px solid rgba(0, 102, 255, 0.15); animation: pulse-ring 2.5s ease-out infinite 0.3s; }
    .logo-circle:nth-child(4) { width: 220px; height: 220px; border: 1px solid rgba(0, 102, 255, 0.08); animation: pulse-ring 3s ease-out infinite 0.6s; }
    @keyframes logoZoom { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.1); } }
    @keyframes pulse-ring { 0% { transform: translate(-50%, -50%) scale(0.8); opacity: 1; } 100% { transform: translate(-50%, -50%) scale(1.3); opacity: 0; } }
    .loader-text { font-size: 24px; font-weight: 700; color: var(--black); margin-top: 30px; letter-spacing: 2px; }
    .loader-text span { display: inline-block; animation: blink 1.4s infinite; }
    .loader-text span:nth-child(2) { animation-delay: 0.2s; }
    .loader-text span:nth-child(3) { animation-delay: 0.4s; }
    @keyframes blink { 0%, 60%, 100% { opacity: 0.3; } 30% { opacity: 1; } }
    .loader-subtext { color: rgba(0, 0, 0, 0.6); margin-top: 12px; font-size: 14px; font-weight: 500; }
"@

$content = $content.Replace($oldCSS, $newCSS)

# Remplacer le HTML du loader
$oldHTML = @"
  <div class="loader-overlay" id="pageLoader">
    <div class="loader-content">
      <div class="logo-animation">
        <img src="https://upload.wikimedia.org/wikipedia/fr/c/c7/Logo_Lydia.png?utm_source=fr.wikipedia.org&utm_campaign=index&utm_content=original" alt="Lydia" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); height: 80px; width: auto; z-index: 10;">
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
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
        <img src="https://upload.wikimedia.org/wikipedia/fr/c/c7/Logo_Lydia.png?utm_source=fr.wikipedia.org&utm_campaign=index&utm_content=original" alt="Lydia" style="height: 100px; width: auto; z-index: 10;">
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
      </div>
      <div class="loader-text"><span>L</span><span>o</span><span>a</span><span>d</span><span>i</span><span>n</span><span>g</span></div>
      <div class="loader-subtext">Préparation de votre expérience de paiement</div>
    </div>
  </div>
"@

$content = $content.Replace($oldHTML, $newHTML)

Set-Content $file $content
Write-Host "Loader animation updated!"
