function Write-Confirm ($Message) {
    
    Write-Host "`n`n$Message"
    $Host.UI.ReadLine() > $null
    
}

Write-Host -ForegroundColor Green @"
`n`n
        ┌──────────────────┐
        │                  │
        │   Spotify  API   │
        │                  │
        │  Token Obtainer  │
        │                  │
        └──────────────────┘
        
        
        
"@

Write-Host -ForegroundColor Cyan "You are about to be directed to the Spotify Developer Dashboard."
Write-Host "Create a new app once you have logged in."
Write-Host "You are free to name your app something like 'Self Scripts'."

Write-Confirm "Press ENTER to continue to your internet browser..."
Start-Process "https://developer.spotify.com/dashboard/"

Write-Confirm "Press ENTER to confirm that you've created a new app..."

Set-Clipboard -Value "https://example.com/"
Write-Host -ForegroundColor Cyan "`n`nThe URL to example.com has just been copied to your clipboard."
Write-Host "On your app's page, under 'Edit Settings', add a 'Redirect URI' by pasting in the contents of your clipboard (the URL)."
Write-Host "Save the settings once you've done that."

Write-Confirm "Press ENTER to confirm you've saved the Redirect URI..."

Write-Host -ForegroundColor Cyan "`n`nNow you will need to supply the two keys from your app's page."
$ClientId = Read-Host "Enter your 'Client ID'"
$ClientSecret = Read-Host "Enter your 'Client Secret'"

Write-Host -ForegroundColor Cyan "`n`nYou are about to be directed to your browser to confirm that you authorize your app to make changes to your account."
Write-Host "Once you've accepted and are redirected to example.com, pay attention to your address bar."
Write-Host "The URL will now contain a query string with a key named 'code'."
Write-Host "Copy this key. (Everything coming AFTER the ?code= part)"

Write-Confirm "Press ENTER to continue to your internet browser..."
Start-Process "https://accounts.spotify.com/en/authorize?client_id=$ClientId&response_type=code&redirect_uri=https:%2F%2Fexample.com%2F&scope=user-library-read%20user-library-modify%20user-read-currently-playing"
# The URL above declares the scopes your API token will be given. Modify to your liking if need be.

Write-Confirm "Press ENTER to confirm that you've copied the code..."

$AuthCode = Read-Host "Enter the code you've copied"

$RefreshToken = (
    Invoke-RestMethod `
    -Method POST `
    -Uri https://accounts.spotify.com/api/token `
    -Body @{
        grant_type = "authorization_code"; 
        code = $AuthCode; 
        redirect_uri = "https://example.com/"; 
        client_id = $ClientId; 
        client_secret = $ClientSecret 
    }
).refresh_token

$JsonObject = @{
    refresh_token = $RefreshToken;
    client_id = $ClientId;
    client_secret = $ClientSecret
} | ConvertTo-Json

Write-Host -ForegroundColor Cyan "`n`nYour credentials are ready to use."
Write-Host "Note that they will also be saved in 'spotify-credentials.json' in plain-text, which is considered UNSAFE."
Write-Host -ForegroundColor Red "The responsibility lies with you on this matter."

$JsonObject | Out-File ".\spotify-credentials.json"
Write-Host "`nHere is the output:"
Write-Host "$JsonObject"
Write-Host "`n`n"

Write-Host "You can learn more about the Spotify authorization flow on here:"
Write-Host "https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow"
Write-Host "`n`n"
