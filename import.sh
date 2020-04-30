#!/bin/sh
#
# Import commands from the shell repository

__import_fetch () {
	kind=$1; shift
	lib=$1; shift

	if [ -d "${XDG_RUNTIME_DIR}" ]; then
		cache_dir="${XDG_RUNTIME_DIR}/shell-import-cache"
	else
		cache_dir="/tmp/$(id -u).shell-import-cache"
	fi

	mkdir -p "${cache_dir}/${kind}/$(dirname "${lib}")"

	src="https://xurtis.pw/import/${kind}/${lib}.sh"
	dest="$(realpath -m ${cache_dir}/${kind}/${lib}.sh)"

	if ! curl -Lfs -o "${dest}" "${src}"; then
		echo "Could not find: ${lib}" > /dev/stderr && false
		return
	fi

	echo "${dest}"
}

import () {
	if [ "$#" -ne "1" ]; then
		echo '`import` takes one argument' > /dev/stderr && false
		return
	fi

	file=$(__import_fetch "libs" $@)

	if [ ! -f "${file}" ]; then
		false
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
			false; \
			return; \
		fi; \
	)
}
