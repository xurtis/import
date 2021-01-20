install_file () {
	scope; var src = $1; var dest = $2;
	mkdir -p "${dest%/*}"
	cp -l "${src}" "${dest}"
	scope_return
}

install_many () {
	scope; var src = $1; var dest = $2; shift 2
	var src_file = ""
	var dest_file = ""

	for file in "$@"; do
		src_file="${src%/}/${file#/}"
		dest_file="${dest%/}/${file#/}"
		install_file "$src_file" "$dest_file"
	done

	scope_return
}
