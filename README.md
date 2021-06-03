# Spotify Scripts

*Spotify scripts to extend the capability of Spotify services.*

- **spotify-add-current**: Allows adding the currently playing track to the user's library without having to interact with the Spotify UI. Can be used to add a keybind to save songs. Uses the Spotify Web API in the background.

----------

## Prerequisites

- PowerShell 7.1+
- BurntToast module for notifications
(Optional; required for notifications)

----------

## Usage

Start by downloading the files. You can either clone the repository, or download as a ZIP and extract.

Then, you need to obtain a Spotify Web API token in order to use the scripts:

1. Go to the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/). Create a new app.
2. On your app's page, edit settings. Add a "Redirect URI" pointing exactly to `https://google.com/`. Save the settings.
(It does not actually matter what website you choose to enter here, since it will only be a temporary placeholder. Using Google is fine.)
3. In the following link, replace `YOUR_CLIENT_ID` with the client ID shown on your app's page. Then open the link and authorize the application.
`https://accounts.spotify.com/en/authorize?client_id=YOUR_CLIENT_ID&response_type=code&redirect_uri=https:%2F%2Fgoogle.com%2F&scope=user-library-read%20user-library-modify%20user-read-currently-playing`
4. You will be redirected to Google, but the URL will contain a query string `code`. Copy the whole code.
(Meaning, everything **coming after** `?code=`)
5. On your app's page, have the client ID and client secret handy.
6. Pull up a PowerShell 7.1 command prompt. Run the following command:
`(Invoke-RestMethod -Method POST -Uri https://accounts.spotify.com/api/token -Body @{ grant_type = "authorization_code"; code = (Read-Host "Enter the code found in step 4"); redirect_uri = "https://google.com/"; client_id = (Read-Host "Enter the client ID"); client_secret = (Read-Host "Enter the Client Secret") }).refresh_token`
7. Copy the code you are given by the command. Paste this code into the file `spotify-credentials-template.json`, as the value to the key called `refresh_token`. Also fill in your client ID and client secret in this file.
8. Rename the file `spotify-credentials-template.json` to be `spotify-credentials.json`

(**Optional**) Install the BurntToast module to see notifications when the script is run.

You should now be able to run the `spotify-add-current.ps1` script (IMPORTANT: using PowerShell 7.1+) whenever you want to add/remove the currently playing track to/from your library.

Furthermore, you may want to package the necessary files as a single binary file.

----------

## Packaging as EXE (Windows only)

1. In your start menu, search for the file `iexpress.exe`. Run it as administrator.
2. Use the template `SED` file in this repository, but only after you've edited the `PATH\TO\FOLDER` placeholders to be the correct paths for your system.
3. Complete packaging the scripts.

You can now use the single binary file wherever you want.
