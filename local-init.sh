#!/bin/sh

# Initialise a local instance of import

export __IMPORT_INSTALL_DIR=${0%/*}
export __IMPORT_SCRIPT=$0

shell_import_defined () {
	true
}

__import_fetch () {
	kind=$1; shift
	lib=$1; shift

	echo "${__IMPORT_INSTALL_DIR}/${kind}/${dest}"
}

import () {
	if [ "$#" -ne "1" ]; then
		echo '`import` takes one argument' > /dev/stderr && false
		return
	fi

	file=$(__import_fetch "libs" $@)

	if [ ! -f "${file}" ]; then
		echo "Could not import: $1" > /dev/stderr && false
		return
	fi

	. "${file}"
}

run () {
	if [ "$#" -ne "1" ]; then
		echo '`run` takes one argument' > /dev/stderr && false
		return
	fi

	# Execute in a subshell
	( \
		. "${__IMPORT_SCRIPT}"; \
		file=$(__import_fetch "libs" $@); \
		if [ -f "${file}" ]; then \
			. $(__import_fetch "commands" $@); \
		else \
			echo "Could not run: $1" > /dev/stderr && false \
			return; \
		fi; \
	)
}
