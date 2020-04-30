#!/bin/sh

# Library for SGR ANSI escapes

# SGR constants

__SGR_RESET=0

BOLD=1
FAINT=2
DIM="${FAINT}"
LIGHT="${FAINT}"
MEDIUM=22

ITALIC=3
FRAKTUR=20
REGULAR=23

UNDERLINE=4
DOUBLE_UNDERLINE=21
NO_UNDERLINE=24

SLOW_BLINK=5
RAPID_BLINK=6
FAST_BLINK="${RAPID_BLINK}"
NO_BLINK=25

REVERSE_VIDEO=7
INVERT="${REVERSE_VIDEO}"
NO_REVERSE_VIDEO=27
NO_INVERT="${NO_REVERSE_VIDEO}"

CONCEAL=8
REVEAL=28
NO_CONCEAL="${REVEAL}"

CROSS_OUT=9
STRIKETHROUGH="${CROSS_OUT}"
NO_CROSS_OUT=29
NO_STRIKETHROUGH="${NO_CROSS_OUT}"

FRAME=51
ENCIRCLE=52
NO_FRAME=54

OVERLINE=53
NO_OVERLINE=55

# Color offsets / identifiers
__SGR_BLACK=0
__SGR_RED=1
__SGR_GREEN=2
__SGR_YELLOW=3
__SGR_BLUE=4
__SGR_MAGENTA=5
__SGR_CYAN=6
__SGR_WHITE=7
__SGR_EXTENDED_COLOR=8
__SGR_DEFAULT_COLOR=9

# Basic SGR escapes

__sgr_escape () {
	echo -en "\x1b[$1m"
}

__sgr_reset () {
	__sgr_escape "${__SGR_RESET}"
}

# Color modifiers
__sgr_bright_4bit () {
	expr "$1" "+" "60"
}

__sgr_foreground_3bit () {
	expr "$1" "+" "30"
}

__sgr_background_3bit () {
	expr "$1" "+" "40"
}

# 8-bit SGR colors
__sgr_8bit () {
	echo -n "5;$1"
}

# Accepts values in [0..8)
__sgr_bright_8bit () {
	__sgr_8bit $(expr "$1" "+" "8")
}

# Accepts values in [0..24)
__sgr_grey_8bit () {
	__sgr_8bit $(expr "$1" "+" "232")
}

# Accepts 3 channels from [0..6)
__sgr_color_8bit () {
	__sgr_8bit $(\
		expr \
			"(" "(" "$1" "*" "36" ")" \
			"+" "(" "$2" "*" "6" ")" \
			"+" "$3" \
			"+" "16" \
			")"\
	)
}

# 24-bit SGR colors

# Accepts 3 channels from [0..256)
__sgr_color_24bit () {
	echo -n "2;$1;$2;$3"
}

# Extended color modifiers

__sgr_foreground_extended () {
	echo -n "38;$1"
}

__sgr_background_extended () {
	echo -n "48;$1"
}

# Expanded color constants

__SGR_BR_BLACK=$(__sgr_bright_8bit "${__SGR_BLACK}")
__SGR_BR_RED=$(__sgr_bright_8bit "${__SGR_RED}")
__SGR_BR_GREEN=$(__sgr_bright_8bit "${__SGR_GREEN}")
__SGR_BR_YELLOW=$(__sgr_bright_8bit "${__SGR_YELLOW}")
__SGR_BR_BLUE=$(__sgr_bright_8bit "${__SGR_BLUE}")
__SGR_BR_MAGENTA=$(__sgr_bright_8bit "${__SGR_MAGENTA}")
__SGR_BR_CYAN=$(__sgr_bright_8bit "${__SGR_CYAN}")
__SGR_BR_WHITE=$(__sgr_bright_8bit "${__SGR_WHITE}")
BLACK_FG=$(__sgr_foreground_3bit "${__SGR_BLACK}")
RED_FG=$(__sgr_foreground_3bit "${__SGR_RED}")
GREEN_FG=$(__sgr_foreground_3bit "${__SGR_GREEN}")
YELLOW_FG=$(__sgr_foreground_3bit "${__SGR_YELLOW}")
BLUE_FG=$(__sgr_foreground_3bit "${__SGR_BLUE}")
MAGENTA_FG=$(__sgr_foreground_3bit "${__SGR_MAGENTA}")
CYAN_FG=$(__sgr_foreground_3bit "${__SGR_CYAN}")
WHITE_FG=$(__sgr_foreground_3bit "${__SGR_WHITE}")
BR_BLACK_FG=$(__sgr_foreground_extended "${__SGR_BR_BLACK}")
BR_RED_FG=$(__sgr_foreground_extended "${__SGR_BR_RED}")
BR_GREEN_FG=$(__sgr_foreground_extended "${__SGR_BR_GREEN}")
BR_YELLOW_FG=$(__sgr_foreground_extended "${__SGR_BR_YELLOW}")
BR_BLUE_FG=$(__sgr_foreground_extended "${__SGR_BR_BLUE}")
BR_MAGENTA_FG=$(__sgr_foreground_extended "${__SGR_BR_MAGENTA}")
BR_CYAN_FG=$(__sgr_foreground_extended "${__SGR_BR_CYAN}")
BR_WHITE_FG=$(__sgr_foreground_extended "${__SGR_BR_WHITE}")
BLACK_BG=$(__sgr_background_3bit "${__SGR_BLACK}")
RED_BG=$(__sgr_background_3bit "${__SGR_RED}")
GREEN_BG=$(__sgr_background_3bit "${__SGR_GREEN}")
YELLOW_BG=$(__sgr_background_3bit "${__SGR_YELLOW}")
BLUE_BG=$(__sgr_background_3bit "${__SGR_BLUE}")
MAGENTA_BG=$(__sgr_background_3bit "${__SGR_MAGENTA}")
CYAN_BG=$(__sgr_background_3bit "${__SGR_CYAN}")
WHITE_BG=$(__sgr_background_3bit "${__SGR_WHITE}")
BR_BLACK_BG=$(__sgr_background_extended "${__SGR_BR_BLACK}")
BR_RED_BG=$(__sgr_background_extended "${__SGR_BR_RED}")
BR_GREEN_BG=$(__sgr_background_extended "${__SGR_BR_GREEN}")
BR_YELLOW_BG=$(__sgr_background_extended "${__SGR_BR_YELLOW}")
BR_BLUE_BG=$(__sgr_background_extended "${__SGR_BR_BLUE}")
BR_MAGENTA_BG=$(__sgr_background_extended "${__SGR_BR_MAGENTA}")
BR_CYAN_BG=$(__sgr_background_extended "${__SGR_BR_CYAN}")
BR_WHITE_BG=$(__sgr_background_extended "${__SGR_BR_WHITE}")

# One of 24 shades of grey
grey_fg () {
	__sgr_foreground_extended $(__sgr_grey_8bit "$1")
}
grey_bg () {
	__sgr_background_extended $(__sgr_grey_8bit "$1")
}

# 8-bit color
rgb8_fg () {
	__sgr_foreground_extended $(__sgr_color_8bit "$1" "$2" "$3")
}
rgb8_bg () {
	__sgr_background_extended $(__sgr_color_8bit "$1" "$2" "$3")
}

# 24-bit color
rgb24_fg () {
	__sgr_foreground_extended $(__sgr_color_24bit "$1" "$2" "$3")
}
rgb24_bg () {
	__sgr_background_extended $(__sgr_color_24bit "$1" "$2" "$3")
}

# Multiple fonts from [0..10)
font () {
	expr "$1" + "10"
}

# Apply a set of styles
style () {
	full_style=""
	for style in $@; do
		full_style="${full_style};${style}"
	done

	__sgr_escape "${full_style#;}"
}

# Reset all styles
unstyle () {
	__sgr_reset
}

# Apply a set of styles to a span of text
span () {
	full_style=""
	while [ "$#" -gt "1" ]; do
		style=$1; shift
		full_style="${full_style};${style}"
	done

	__sgr_escape "${full_style#;}"
	echo -en $@
	__sgr_reset
}
