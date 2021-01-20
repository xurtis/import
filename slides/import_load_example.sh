#!/bin/sh

# Remote import
if ! which shell_import_defined 2&>1 > /dev/null; then
	import_script=$(mktemp)
	curl -Ls -o "${import_script}" \
		https://import.xurt.is/import.sh

	# Do the import
	_="${import_script}"
	. "${import_script}"
	rm "${import_script}"
fi

# Rest of script...
