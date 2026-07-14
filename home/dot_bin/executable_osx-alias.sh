#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]
then
echo "This script is intended for use on Darwin (Mac OS)"
ln -s "$1" "$2"
exit 0
fi

if [[ -f "$1" ]]; then
type="file"
else
if [[ -d "$1" ]]; then
if [[ "${1##*.}" = "app" ]]
then
file
else
type="folder"
fi
else
echo "Invalid path or unsupported type"
exit 1
fi
fi

osascript <<END_SCRIPT
tell application "Finder"
make new alias to $type (posix file "$1") at (posix file "$2")
end tell
END_SCRIPT
