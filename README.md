# Spotify Scripts

*Spotify scripts to extend the capability of Spotify services.*

- **spotify-add-current**: Allows adding the currently playing track to the user's library without having to interact with the Spotify UI. Can be used to bind a key to save/unsave songs by executing the script. Uses the Spotify Web API in the background.
- **spotify-api-token-obtainer**: Guides you through the process of obtaining a [Spotify Web API](https://developer.spotify.com/documentation/web-api/) token. No setup needed, just run the script and get your API access in no time.
*Note 1: This token is strictly for personal use.*
*Note 2: The API token you obtain will only have the [scope](https://developer.spotify.com/documentation/general/guides/scopes/) `user-library-read`, `user-library-modify`, `user-read-currently-playing`. If for some reason you need something else, you can easily modify the script (see line ~49).*

----------

## Prerequisites

- [PowerShell 7.1](https://aka.ms/powershell-release?tag=stable) (and above?)
- [BurntToast](https://github.com/Windos/BurntToast) module for notifications
(Optional; required for notifications)

----------

## Usage

Start by downloading the files. You can either clone the repository, or [download as a ZIP](https://github.com/vedattt/spotify-scripts/archive/refs/heads/master.zip) and extract.

Then, you need to obtain a Spotify Web API token in order to use the scripts.
The `spotify-api-token-obtainer.ps1` script will guide you through the process.

(**Optional**) Install the [BurntToast](https://github.com/Windos/BurntToast) module to see notifications when the script is run.

You should now be able to run the `spotify-add-current.ps1` script whenever you want to add/remove the currently playing track to/from your library. Don't forget that it is essential these scripts are run **using PowerShell 7.1+**.

Furthermore, you may want to package the necessary files as a single binary file. See below.

----------

## Packaging as EXE (Windows only)

1. In your start menu, search for the file `iexpress.exe`. Run it as administrator.
2. Use the template `SED` file from this repository, but only after you've edited the `PATH\TO\FOLDER` placeholders to be the correct paths for your system.
3. Complete packaging the scripts.

You can now use the single binary file wherever you want.
