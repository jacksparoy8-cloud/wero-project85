$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\index.ejs"
$content = Get-Content $file -Raw

# Désactiver l'animation du loader au démarrage
$oldCode = @"
    document.addEventListener("DOMContentLoaded", () => {
      const pageLoader = document.getElementById('pageLoader');
      pageLoader.classList.add('active');
      setTimeout(() => { pageLoader.classList.remove('active'); }, 1500);
"@

$newCode = @"
    document.addEventListener("DOMContentLoaded", () => {
      const pageLoader = document.getElementById('pageLoader');
      // Loader animation désactivée
      // pageLoader.classList.add('active');
      // setTimeout(() => { pageLoader.classList.remove('active'); }, 1500);
"@

$content = $content.Replace($oldCode, $newCode)
Set-Content $file $content
Write-Host "Loader animation disabled!"
