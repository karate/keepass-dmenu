This script uses keepassxc-cli to load passwords from the database
and dmenu to allow the user to select an entry.

The password for the selected entry is then copied to the clipboard, and
stays there for a specified ammount of time. After that it's being deleted

The script assumes that you only use a key file and not a password. If you
use a password (and you should), just remove the `--no-password` switch, and
let gnome-keyring or kdewallet do their stuff

Requirements:
- keepassxc-cli (comes with keepassxc)
- notify-send (comes with libnotify, you probably already have this)
- dmenu

Usage:
Assing a keyboard shortcut to run this script.


Click below for a demo:
[![Watch a demo](https://raw.githubusercontent.com/karate/keepass-dmenu/master/screenshot.png)](https://github.com/karate/keepass-dmenu/blob/master/keepass_dmenu.webm?raw=true)
