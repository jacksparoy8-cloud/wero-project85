$file = "C:\Users\user\Desktop\wero\lydia\backend-nodejs\views\index.ejs"
$content = Get-Content $file -Raw
$old = @"
      <div class="logo-animation">
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        
      </div>
"@
$new = @"
      <div class="logo-animation">
        <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjEwMCIgdmlld0JveD0iMCAwIDIwMCAxMDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMzAiIGN5PSI1MCIgcj0iMjUiIGZpbGw9IiMwMDc0RUMiLz48dGV4dCB4PSIzMCIgeT0iNjAiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZvbnQtc2l6ZT0iNDgiIGZvbnQtd2VpZ2h0PSJib2xkIiBmaWxsPSJ3aGl0ZSIgZm9udC1mYW1pbHk9IkFyaWFsIj7L1zwvdGV4dD48dGV4dCB4PSIxMDAiIHk9IjYwIiBmb250LXNpemU9IjU2IiBmb250LXdlaWdodD0iYm9sZCIgZmlsbD0iIzAwMDMzRiIgZm9udC1mYW1pbHk9IkFyaWFsIj5MeWRpYTwvdGV4dD48L3N2Zz4=" alt="Lydia" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); height: 100px; width: auto; z-index: 10;">
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
        <div class="logo-circle"></div>
      </div>
"@
$content = $content.Replace($old, $new)
Set-Content $file $content
Write-Host "Logo fixed in index.ejs"
