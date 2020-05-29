#!/bin/bash

error() {
	echo "Usage: $0 [-f] /full/path/to/files"
	echo "       -f: force, recreate existing files."
	exit 1
}

FORCE=false

while getopts ":f" Option; do
	case $Option in
		f) FORCE=true;;
		*) error;;
	esac
done
shift $((OPTIND -1))

[[ $# -ne 1 ]] && error

FILE_PATH="$1"
FILES=$(find $FILE_PATH/ -name "*.zip")

for file in $FILES; do
	filename=$(basename $file).sha256sum
	if [[ -e $filename && $FORCE = "false" ]]; then continue; fi
	echo $filename
	sha256sum $file | awk '{printf $1}' > $filename
done