This script uses keepassxc-cli to load passwords and other properties
from the keepassxc database, and dmenu to allow the user to select an entry.

After selecting an entry with dmenu, it lists all properties for this
entry (Username, masked Pasword, URL and Notes).

If the user selects the Password, it uses keepassxc to load the password,
copy it in the clipboard and delete it after some time.

If the user selects any other property, it uses xclip to copy the contents
to the clipboard.

The script assumes that you only use a key file and not a password. If you
use a password (and you should), just remove the --no-password switch, and
let gnome-keyring or kdewallet do their stuff

Requirements:
- keepassxc-cli (comes with keepassxc)
- notify-send (comes with libnotify, you probably already have this)
- xclip (you should already have this as well)
- dmenu

Usage:
Assing a keyboard shortcut to run this script.

Click below for a demo:
[![Watch a demo](https://raw.githubusercontent.com/karate/keepass-dmenu/master/screenshot.png)](https://github.com/karate/keepass-dmenu/blob/master/keepass_dmenu.webm?raw=true)
