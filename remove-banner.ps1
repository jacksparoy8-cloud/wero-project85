$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\index.ejs"
$content = Get-Content $file -Raw

# Supprimer la banner section
$content = $content -replace '\s*<div class="banner-section">\s*<img src="https://epicompany\.eu/storage/images/Lydia-Pay-post\.png" alt="Lydia" class="banner-image">\s*</div>\s*', ''

Set-Content $file $content
Write-Host "Banner image removed successfully!"
