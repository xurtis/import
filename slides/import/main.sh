#!/bin/dash

# Use local import
_=../../local-init.sh
. "$_"

# Colour is already a builtin
import color using \
	span style unstyle \
	RED_FG CYAN_FG BR_YELLOW_FG \
	ITALIC BOLD REGULAR

fn main
main () {
	echo "This text is $(span $ITALIC $RED_FG "red")"
	echo "$(style $CYAN_FG)This text is" \
		"$(style $BR_YELLOW_FG $BOLD $ITALIC)A E S T H E T I C" \
		"$(style $CYAN_FG $REGULAR)!!!$(unstyle)"
}

# Call main
main
