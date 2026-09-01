$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\index.ejs"
$content = Get-Content $file -Raw

# Remplacer le loader avec une nouvelle animation
$oldLoader = @"
  <div class="loader-overlay" id="pageLoader">
    <div class="loader-content">
      <div class="logo-animation">
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        
      </div>
      <div class="loader-text">Chargement</div>
      <div class="loader-subtext">Préparation de votre expérience de paiement</div>
    </div>
  </div>
"@

$newLoader = @"
  <div class="loader-overlay" id="pageLoader">
    <div class="loader-content">
      <div class="logo-animation">
        <img src="https://upload.wikimedia.org/wikipedia/fr/c/c7/Logo_Lydia.png?utm_source=fr.wikipedia.org&utm_campaign=index&utm_content=original" alt="Lydia" style="height: 100px; width: auto; z-index: 10;">
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
      </div>
      <div class="loader-text"><span>L</span><span>o</span><span>a</span><span>d</span><span>i</span><span>n</span><span>g</span>...</div>
      <div class="loader-subtext">Sécurisation de votre connexion</div>
    </div>
  </div>
"@

$content = $content.Replace($oldLoader, $newLoader)

# Ajouter le CSS pour la nouvelle animation
$oldCss = '.loader-text { font-size: 20px; font-weight: 700; color: var(--black); margin-top: 20px; }
    .loader-subtext { color: rgba(0, 0, 0, 0.6); margin-top: 10px; font-size: 14px; }'

$newCss = @"
.loader-text { 
  font-size: 20px; 
  font-weight: 700; 
  color: var(--black); 
  margin-top: 20px;
  letter-spacing: 2px;
}
.loader-text span {
  display: inline-block;
  animation: letterBounce 1.4s infinite;
}
.loader-text span:nth-child(1) { animation-delay: 0s; }
.loader-text span:nth-child(2) { animation-delay: 0.1s; }
.loader-text span:nth-child(3) { animation-delay: 0.2s; }
.loader-text span:nth-child(4) { animation-delay: 0.3s; }
.loader-text span:nth-child(5) { animation-delay: 0.4s; }
.loader-text span:nth-child(6) { animation-delay: 0.5s; }
.loader-text span:nth-child(7) { animation-delay: 0.6s; }
@keyframes letterBounce {
  0%, 60%, 100% { transform: translateY(0); opacity: 0.5; }
  30% { transform: translateY(-20px); opacity: 1; }
}
.loader-subtext { 
  color: rgba(0, 0, 0, 0.6); 
  margin-top: 10px; 
  font-size: 14px;
  animation: fadeInOut 2s infinite;
}
@keyframes fadeInOut {
  0%, 100% { opacity: 0.5; }
  50% { opacity: 1; }
}
"@

$content = $content.Replace($oldCss, $newCss)

Set-Content $file $content
Write-Host "Loader restored with new animation!"
