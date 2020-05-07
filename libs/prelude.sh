#!/bin/sh

# Standard prelude for import

# Mark import as having been initialised
shell_import_init () {
	true
}

# Dummy definition of use
use () {
	if [ "$#" -gt 1 ]; then
		echo "Cannot 'import $@' until 'module' library is loaded"
		return 1
	fi
}

# Import a library without brining values into scope
instantiate_library () {
	eval "__import_imported=\${__import_LIB_$1+imported}"
	if [ "${__import_imported}" = "imported" ]; then
		if [ "$2" != "forced" ]; then
			return
		fi
	fi

	if ! __import_direct "libs" "$1"; then
		echo "Could not import: $1" > /dev/stderr
		return 1
	fi

	eval "__import_LIB_$1=imported"
}

# Command to import a library
import () {
	if ! instantiate_library "$1"; then
		return 1
	fi

	use "$@"
}

# Command to run a command (executes in a subshell)
run () (
	__import_direct "commands" "$@"
)

# Additional prelude imports
import module
