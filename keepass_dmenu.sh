#!/usr/bin/bash
#
# Description:
# This script uses keepassxc-cli to load passwords and other properties
# from the keepassxc database, and dmenu to allow the user to select an entry.
#
# After selecting an entry with dmenu, it lists all properties for this
# entry (Username, masked Pasword, URL and Notes).
#
# If the user selects the Password, it uses keepassxc to load the password,
# copy it in the clipboard and delete it after some time.
#
# If the user selects any other property, it uses xclip to copy the contents
# to the clipboard.
#
# The script assumes that you only use a key file and not a password. If you
# use a password (and you should), just remove the --no-password switch, and
# let gnome-keyring or kdewallet do their stuff
#
# Requirements:
# - keepassxc-cli (comes with keepassxc)
# - notify-send (comes with libnotify, you probably already have this)
# - xclip (you should already have this as well)
# - dmenu
#
# Usage:
# Assing a keyboard shortcut to run this script.

#####################
### CONFIGURATION ###
#####################

# Key file
KEY_FILE=/path/to/keyfile.key
# Database file
DB_FILE=/path/to/database.kdbx
# Start from specified entry
SELECTED_ENTRY='default-group'
# Timeout before the password is deleted from clipbord
TIMEOUT=5

#################
### FUNCTIONS ###
#################

# Get all entries and pass them to dmenu, to allow the user to select one
function show_entries {
	if [[ ! -z "$1" ]]; then
		# Trim tailing slash
		INPUT="${1/\//}"
		# Append to existing string
		SELECTED_ENTRY=$SELECTED_ENTRY/$INPUT
	fi

	# Get entries
	ENTRY="$(keepassxc-cli ls -k "$KEY_FILE" "$DB_FILE" "$SELECTED_ENTRY" --no-password | dmenu -i -l 10)"
}

# Get the password for the selected entry
function get_pass {

	# Create notification
	notify-send "$SELECTED_ENTRY" "Password copied to clipboard for $TIMEOUT seconds" -t $(( TIMEOUT * 1000 ))
	# Copy password to clipboard
	keepassxc-cli clip -q -k $KEY_FILE $DB_FILE "$SELECTED_ENTRY" --no-password $TIMEOUT
}

# Show entry's contents
function show_entry_contents {
	SELECTED_ENTRY=$SELECTED_ENTRY/$1

	# Get contents of entry, but remove password and title
	CONTENTS=$(keepassxc-cli show -k "$KEY_FILE" "$DB_FILE" "$SELECTED_ENTRY" --no-password | grep -v 'Password: ' | grep -v 'Title: ')
	# Add a dummy password entry, and run dmenu
	INFO=$(echo -e "Password: ***\n$CONTENTS" | dmenu -i -l 10)

	# If the password entry was selected, use keepassxc-cli to copy the password
	# Else, remove the "Label: " string and copy the rest to clipboard
	if [[ $INFO == "Password: ***" ]]; then
		get_pass
	else
		LABEL=$(echo -n $INFO | sed 's/:.*$//g')
		VALUE=$(echo -n $INFO | sed 's/^\w\+:\s\?//g')
		notify-send "$SELECTED_ENTRY" "$LABEL copied to clipboard"
		echo -n $VALUE | xclip -selection clipboard
	fi
}

###############
### PROGRAM ###
###############

show_entries

# If $ENTRY ends in /, show child entries
while [[ $ENTRY = *\/ ]]; do
	show_entries $ENTRY
done

# When a leaf entry is selected, show the entry's contents
if [[ ! -z $ENTRY ]]; then
	show_entry_contents "$ENTRY"
fi
