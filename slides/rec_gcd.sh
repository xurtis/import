rec_gcd () {
	a=$1; shift
	b=$1; shift

	if [ "$b" -gt 0 ]; then
		echo "$(rec_gcd "$b" $((a % b)))"
	else
		echo "$a"
	fi
}
