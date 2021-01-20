install_file () {
	src=$1; dest=$2;
	mkdir -p "${dest%/*}"
	cp -l "${src}" "${dest}"
}

install_many () {
	src=$1; dest=$2; shift 2

	for file in "$@"; do
		src_file="${src%/}/${file#/}"
		dest_file="${dest%/}/${file#/}"
		install_file "$src_file" "$dest_file"
	done
}
