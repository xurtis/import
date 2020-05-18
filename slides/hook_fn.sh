install_file () {
	scope

	src=$1; dest=$2;
	mkdir -p "${dest%/*}"
	cp -l "${src}" "${dest}"

	scope_return
}
