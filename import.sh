#!/bin/sh
#
# Import commands from the shell repository

import () {
	if [ "$#" -ne "1" ]; then
		echo 'Command `import` takes one argument' && false
		return
	fi

	lib=$1; shift

	if [ -d "${XDG_RUNTIME_DIR}" ]; then
		cache_dir="${XDG_RUNTIME_DIR}/shell-import-cache"
	else
		cache_dir="/tmp/$(id -u).shell-import-cache"
	fi

	mkdir -p "${cache_dir}/$(dirname "${lib}")"

	src="https://xurtis.pw/import/libs/${lib}.sh"
	dest="$(realpath -m ${cache_dir}/${lib}.sh)"

	if ! curl -Ls -o "${dest}" "${src}"; then
		echo "Could not import library: ${lib}" && false
		return
	fi

	source "${dest}"
}
