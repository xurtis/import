#!/bin/sh

# Module for creating and presenting slides
module "slides"

from color use span BOLD WHITE_FG
from term use \
	move_absolute \
	move_line_absolute \
	clear_display \
	clear_line

const WIDTH = "$(tput cols)"
const HEIGHT = "$(tput lines)"

# Number of slides to show
var count = 0

pub fn chars
chars () {
	scope slides
	var line = "$1"; shift
	var chars = 0
	var first = ""
	var rest = ""
	var truncated = ""
	const ESCAPE = "$(printf "\033")"

	while [ "${#line}" -gt 0 ]; do
		rest="${line##?}"
		first="${line%%"$rest"}"

		# Skip SGR escapes
		if [ "${first}" = "${ESCAPE}" ]; then
			line="${rest#*m}"
			continue
		fi

		chars=$(( chars + 1 ))
		line="${rest}"
	done

	echo "${chars}"

	scope_return
}

# Redraw a slide to place it in the center of the terminal
pub fn redraw
redraw () {
	scope slides using WIDTH HEIGHT
	var width = "$1"; shift
	var height = "$1"; shift

	var pad_left = $(( (WIDTH - width) / 2 ))
	var pad_top = $(( ( (HEIGHT - height) - 2 ) / 2 ))
	var pad_bottom = "${pad_top}"

	while [ "${pad_top}" -gt 0 ]; do
		echo
		pad_top=$(( pad_top - 1 ))
	done

	var inner_pad_left = "${pad_left}"
	while IFS= read line; do
		inner_pad_left="${pad_left}"
		while [ "${inner_pad_left}" -gt 0 ]; do
			printf " "
			inner_pad_left=$(( inner_pad_left - 1 ))
		done

		echo "${line}"
	done

	while [ "${pad_bottom}" -gt 0 ]; do
		echo
		pad_bottom=$(( pad_bottom - 1 ))
	done

	scope_return
}

# Show the render progress
fn render_progress
render_progress () {
	scope slides using clear_line move_line_absolute count
	clear_line
	move_line_absolute 0
	printf "Rendering slide %d..." "$(( count + 1 ))"
	scope_return
}

# Add a new slide to the slideshow
pub fn slide
slide () {
	scope slides using chars redraw count render_progress
	var lines = 1
	var length = 0
	var longest = 0
	var text = ""

	render_progress

	while IFS= read line; do
		line=$(echo "${line}" | sed -e "s/\t/    /g")
		length="$(chars "$line")"
		if [ "${length}" -gt "${longest}" ]; then
			longest="${length}"
		fi

		text="${text}${line}\n"
		lines=$(( lines + 1 ))
	done

	# Save the rendered slide
	var slide = "$(echo "${text}" | redraw "${longest}" "${lines}")"
	eval "__slides_SLIDE_${count}=\"\$slide\""
	count=$(( count + 1 ))

	scope_return
}

# Display a slide number
fn show_number
show_number () {
	scope slides using \
		count \
		HEIGHT \
		WIDTH \
		move_absolute \
		move_line_aboslute \
		clear_line \
		span \
		BOLD \
		WHITE_FG


	var number = "$1"; shift

	var info = "Slide $(( number + 1 )) of ${count}"
	var info_width = "${#info}"
	info="Slide $(span $BOLD $WHITE_FG "$(( number + 1 ))") of $(span $BOLD $WHITE_FG "${count}")"

	var padding = "$(( (WIDTH - info_width) / 2 ))"

	move_absolute $(( HEIGHT - 2 )) 1
	clear_line
	move_line_absolute $padding

	echo "${info}"

	scope_return
}

# Interactive shell
fn interactive
interactive () (
	_="${__import_SCRIPT}"
	. "${__import_SCRIPT}"
	reimport prelude
	reimport module
	clear

	set -i
	printf "$ "
	while IFS= read line; do
		eval $line
		printf "$ "
	done
)

# Present the slide show
pub fn present
present () {
	scope slides
	var current = 0
	var action = 0
	var slide = 0
	var slide_counter = ""
	var slide_counter_width = 0

	while [ "$current" -lt "$count" ]; do

		# Show the slide content

		clear_display
		move_absolute 1 1

		eval "printf \"%s\n\" \"\$__slides_SLIDE_${current}\""

		# Show slide number

		slide_counter="Slide $(( current + 1 )) of ${count}"
		slide_counter_width="${#slide_counter}"
		slide_counter="Slide $(span $BOLD $WHITE_FG "$(( current + 1 ))") of $(span $BOLD $WHITE_FG "${count}")"

		move_absolute $(( HEIGHT - 2 )) 1
		clear_line
		move_line_absolute "$(( (WIDTH - slide_counter_width) / 2 ))"

		echo "${slide_counter}"

		# Show command prompt

		clear_line

		stty -opost -icanon -echo
		action=$(dd if=/dev/stdin bs=1 count=1 2>/dev/null)
		stty cooked echo

		# Respond to prompt


		case "$action" in
			"e")
				scope_return
				;;
			"q")
				scope_return
				;;
			"s")
				printf "> "
				read slide
				current=$((slide - 1))
				;;
			"p")
				current=$((current - 1))
				;;
			"n")
				current=$((current + 1))
				;;
			"")
				current=$((current + 1))
				;;
			"i")
				interactive
				;;
		esac
	done


	scope_return
}

end_module
