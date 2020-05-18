install_file () {
	scope
	var src = $1
	var dest = $2

	mkdir -p "${dest%/*}"
	cp -l "${src}" "${dest}"

	scope_return
}
