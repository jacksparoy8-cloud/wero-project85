$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\premiere.ejs"
$content = Get-Content $file -Raw

# Supprimer le texte inutile
$content = $content -replace '(?s)Je vais lire.*?💙', ''

Set-Content $file $content
Write-Host "Texte supprimé!"
