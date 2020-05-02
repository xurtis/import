#!/bin/sh

# Initialise a local instance of import

export __import_SCRIPT=$(realpath -e $_)
export __import_INSTALL_DIR=${__import_SCRIPT%/*}

__import_fetch () {
	__import_kind=$1; shift
	__import_lib=$1; shift

	echo "${__import_INSTALL_DIR}/${__import_kind}/${__import_lib}.sh"

	unset __import_kind
	unset __import_lib
}

# Import a library directly into the global scope
__import_direct () {
	__import_kind=$1; shift
	__import_name=$1; shift
	__import_file=$(__import_fetch "$__import_kind" "$__import_name")

	if [ ! -f "${__import_file}" ]; then
		unset __import_kind
		unset __import_name
		unset __import_file
		return 1
	fi

	. "${__import_file}" "$@"
	unset __import_kind
	unset __import_name
	unset __import_file
}

# Import a library expected to end up at a particular location
__import_to_path () {
	true
}

# Reload the import script from the source
import_refresh () {
	source "${__import_SCRIPT}"
}

# Import the prelude module
__import_direct "libs" prelude
