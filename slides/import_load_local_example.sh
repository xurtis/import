#!/bin/sh

# Local import
if ! which shell_import_defined 2&>1 > /dev/null; then
	import_script=/path/to/import/local-init.sh

	# Do the import
	_="${import_script}"
	. "${import_script}"
fi

# Rest of script...
