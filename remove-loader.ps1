$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\index.ejs"
$content = Get-Content $file -Raw

# Supprimer tout le div loader-overlay
$content = $content -replace '(?s)<div class="loader-overlay".*?</div>\s*', ''

Set-Content $file $content
Write-Host "Loader removed!"
