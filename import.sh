#!/bin/sh
#
# Import commands from the shell repository

shell_import_defined () {
	true
}

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
		import_script=$(mktemp); \
		curl -Ls \
			-o "${import_script}" \
			https://xurtis.pw/import/import.sh; \
		. "${import_script}"; \
		rm "${import_script}"; \
		file=$(__import_fetch "libs" $@); \
		if [ -f "${file}" ]; then \
			. $(__import_fetch "commands" $@); \
		else \
			echo "Could not run: $1" > /dev/stderr && false \
			return; \
		fi; \
	)
}
