#!/bin/sh

# Initialise a local instance of import

__IMPORT_INSTALL_DIR=${0%/*}

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

	source "${file}"
}

run () {
	if [ "$#" -ne "1" ]; then
		echo '`run` takes one argument' > /dev/stderr && false
		return
	fi

	# Execute in a subshell
	( \
		source <(curl -Ls https://xurtis.pw/import/import.sh); \
		file=$(__import_fetch "libs" $@); \
		if [ -f "${file}" ]; then \
			source $(__import_fetch "commands" $@); \
		else \
			echo "Could not run: $1" > /dev/stderr && false \
			return; \
		fi; \
	)
}
