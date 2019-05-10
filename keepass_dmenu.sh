#!/usr/bin/bash
#
# Description:
# This script uses keepassxc-cli to load passwords from the database
# and dmenu to allow the user to select an entry.
# 
# The password for the selected entry is then copied to the clipbord, and
# stays there for a specified ammount of time. After that it's being deleted
#
# The script assumes that you only use a key file and not a password. If you 
# use a password (and you should), just remove the --no-password switch, and
# let gnome-keyring or kdewallet do their stuff
#
# Requirements:
# - keepassxc-cli (comes with keepassxc)
# - notify-send (comes with libnotify, you probably already have this)
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
	ENTRY=$(keepassxc-cli ls -k $KEY_FILE $DB_FILE $SELECTED_ENTRY --no-password | dmenu -l 10)
}

# Get the password for the selected entry
function get_pass {
	SELECTED_ENTRY=$SELECTED_ENTRY/$1
	
	# Create notification
	notify-send "$SELECTED_ENTRY" "Password copied to clipboard for $TIMEOUT seconds" -t $(( TIMEOUT * 1000 ))
	# Copy password to clipboard
	keepassxc-cli clip -q -k $KEY_FILE $DB_FILE $SELECTED_ENTRY --no-password $TIMEOUT
}

###############
### PROGRAM ###
###############

show_entries

# If $ENTRY ends in /, show child entries
while [[ $ENTRY = *\/ ]]; do
	show_entries $ENTRY
done

# When a leaf entry is selected, copy the password
if [[ ! -z $ENTRY ]]; then
	get_pass $ENTRY
fi
