factorial () {
	x=$1; shift

	if [ "$x" -eq 0 ]; then
		echo 1
	else
		factor=$(factorial $((x - 1)))
		echo $((factor * x))
	fi
}
