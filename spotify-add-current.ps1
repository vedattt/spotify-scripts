$CredentialFile = Get-Content .\spotify-credentials.json | ConvertFrom-Json

$RefreshToken = $CredentialFile.refresh_token
$ClientSecret = $CredentialFile.client_secret
$ClientId = $CredentialFile.client_id

if (-NOT (Get-Process spotify -ErrorAction SilentlyContinue)) {
    Exit
}

$AccessToken = (
    Invoke-RestMethod `
    -Method POST `
    -Uri https://accounts.spotify.com/api/token `
    -Body @{ 
        grant_type = "refresh_token"; 
        refresh_token = $RefreshToken; 
        client_id = $ClientId; 
        client_secret = $ClientSecret
}).access_token | ConvertTo-SecureString -AsPlainText -Force

$CurrentTrack = (
    Invoke-RestMethod `
    -Uri https://api.spotify.com/v1/me/player/currently-playing `
    -Authentication OAuth `
    -Token $AccessToken
)

$LibraryContainsTrack = (
    Invoke-RestMethod `
    -Uri https://api.spotify.com/v1/me/tracks/contains `
    -Authentication OAuth `
    -Token $AccessToken `
    -Body @{
        ids = $CurrentTrack.item.id
    }
)

Invoke-RestMethod `
-Uri https://api.spotify.com/v1/me/tracks `
-Method $( If ($LibraryContainsTrack) {"DELETE"} else {"PUT"} ) `
-Authentication OAuth `
-Token $AccessToken `
-ContentType "application/json" `
-Body (@{
    ids = @( $CurrentTrack.item.id )
} | ConvertTo-Json)

if (Get-Command New-BurntToastNotification -ErrorAction Stop) {
    
    $notificationTitle = If ($LibraryContainsTrack) {"Removed song from library"} else {"Added song to library"}
    $notificationMessage = "Artist: " + $CurrentTrack.item.artists[0].name + "`nTrack: " + $CurrentTrack.item.name
    
    New-BurntToastNotification -Silent -Text $notificationTitle, $notificationMessage -AppLogo .\spotify-logo.png
    
}
