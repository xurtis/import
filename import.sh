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
		echo "Could not find: ${lib}" && false
		return
	fi

	source "${dest}"
}


import () {
	if [ "$#" -ne "1" ]; then
		echo 'Command `import` takes one argument' && false
		return
	fi

	__import_fetch "libs" $@
}

run () {
	if [ "$#" -ne "1" ]; then
		echo 'Command `run` takes one argument' && false
		return
	fi

	__import_fetch "commands" $@
}
