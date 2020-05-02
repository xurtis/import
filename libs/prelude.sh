#!/bin/sh

# Standard prelude for import

# Mark import as having been initialised
shell_import_init () {
	true
}

# Command to import a library
import () {
	if [ "$#" -ne "1" ]; then
		echo '`import` takes one argument' > /dev/stderr
		return 1
	fi

	if ! __import_direct "libs" "$1"; then
		echo "Could not import: $1" > /dev/stderr
		return 1
	fi
}

# Command to run a command (executes in a subshell)
run () (
	__import_direct "commands" "$@"
)

# Additional prelude imports
import module
