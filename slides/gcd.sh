gcd () {
	a=$1; shift
	b=$1; shift

	if [ "$b" -gt 0 ]; then
		while \
			[ $((a = a % b)) -gt 0 ] && \
			[ $((b = b % a)) -gt 0 ]
		do
			true
		done
	fi

	echo $((a + b))
}
