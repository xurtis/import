#!/bin/sh
#
# Import commands from the shell repository

export __import_src_SCRIPT=$(realpath -e $_)

if [ -d "${XDG_RUNTIME_DIR}" ]; then
	__SHELL_IMPORT_CACHE_DIR="${XDG_RUNTIME_DIR}/shell-import-cache"
else
	__SHELL_IMPORT_CACHE_DIR="/tmp/$(id -u).shell-import-cache"
fi
mkdir -p "${__SHELL_IMPORT_CACHE_DIR}"

export __import_SCRIPT="${__SHELL_IMPORT_CACHE_DIR}/import.sh"
cp "${__import_src_SCRIPT}" "${__import_SCRIPT}"

# Download the library from the internet
__import_fetch () {
	__import_kind=$1; shift
	__import_lib=$1; shift

	mkdir -p "${__SHELL_IMPORT_CACHE_DIR}/${__import_kind}/$(dirname "${__import_lib}")"

	__import_src="https://import.xurt.is/${__import_kind}/${__import_lib}.sh"
	__import_dest="$(realpath -m ${__SHELL_IMPORT_CACHE_DIR}/${__import_kind}/${__import_lib}.sh)"

	if curl -Lfs -o "${__import_dest}" "${__import_src}"; then
		echo "${__import_dest}"
	fi

	unset __import_kind
	unset __import_lib
	unset __import_cache_dir
	unset __import_src
	unset __import_dest
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

# The online version of import always fetches the latest version of a
# library or command
import_refresh () {
	true
}

# Import the prelude module
__import_direct "libs" prelude
