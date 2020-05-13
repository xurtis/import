#!/bin/sh

module color

# Library for SGR ANSI escapes

# SGR constants

const SGR_RESET = 0

pub const BOLD = 1
pub const FAINT = 2
pub const DIM = "${FAINT}"
pub const LIGHT = "${FAINT}"
pub const MEDIUM = 22

pub const ITALIC = 3
pub const FRAKTUR = 20
pub const REGULAR = 23

pub const UNDERLINE = 4
pub const DOUBLE_UNDERLINE = 21
pub const NO_UNDERLINE = 24

pub const SLOW_BLINK = 5
pub const RAPID_BLINK = 6
pub const FAST_BLINK = "${RAPID_BLINK}"
pub const NO_BLINK = 25

pub const REVERSE_VIDEO = 7
pub const INVERT = "${REVERSE_VIDEO}"
pub const NO_REVERSE_VIDEO = 27
pub const NO_INVERT = "${NO_REVERSE_VIDEO}"

pub const CONCEAL = 8
pub const REVEAL = 28
pub const NO_CONCEAL = "${REVEAL}"

pub const CROSS_OUT = 9
pub const STRIKETHROUGH = "${CROSS_OUT}"
pub const NO_CROSS_OUT = 29
pub const NO_STRIKETHROUGH = "${NO_CROSS_OUT}"

pub const FRAME = 51
pub const ENCIRCLE = 52
pub const NO_FRAME = 54

pub const OVERLINE = 53
pub const NO_OVERLINE = 55

# Color offsets / identifiers
const SGR_BLACK = 0
const SGR_RED = 1
const SGR_GREEN = 2
const SGR_YELLOW = 3
const SGR_BLUE = 4
const SGR_MAGENTA = 5
const SGR_CYAN = 6
const SGR_WHITE = 7
const SGR_EXTENDED_COLOR = 8
const SGR_DEFAULT_COLOR = 9

# Basic SGR escapes

fn sgr_escape
sgr_escape () {
	printf "\033[%sm" "$*"
}

fn sgr_reset
sgr_reset () {
	printf "\033[0m"
}

# Color modifiers
fn sgr_bright_4bit
sgr_bright_4bit () {
	expr "$1" "+" "60"
}

fn sgr_foreground_3bit
sgr_foreground_3bit () {
	expr "$1" "+" "30"
}

fn sgr_background_3bit
sgr_background_3bit () {
	expr "$1" "+" "40"
}

# 8-bit SGR colors
fn sgr_8bit
sgr_8bit () {
	printf "%s" "5;$1"
}

# Accepts values in [0..8)
fn sgr_bright_8bit
sgr_bright_8bit () {
	scope color using sgr_8bit

	sgr_8bit $(expr "$1" "+" "8")

	scope_return
}

# Accepts values in [0..24)
fn sgr_grey_8bit
sgr_grey_8bit () {
	scope color using sgr_8bit

	sgr_8bit $(expr "$1" "+" "232")

	scope_return
}

# Accepts 3 channels from [0..6)
fn sgr_color_8bit
sgr_color_8bit () {
	scope color using sgr_8bit

	sgr_8bit $(\
		expr \
			"(" "(" "$1" "*" "36" ")" \
			"+" "(" "$2" "*" "6" ")" \
			"+" "$3" \
			"+" "16" \
			")"\
	)

	scope_return
}

# 24-bit SGR colors

# Accepts 3 channels from [0..256)
fn sgr_color_24bit
sgr_color_24bit () {
	printf "%s" "2;$1;$2;$3"
}

# Extended color modifiers

fn sgr_foreground_extended
sgr_foreground_extended () {
	printf "%s" "38;$1"
}

fn sgr_background_extended
sgr_background_extended () {
	printf "%s" "48;$1"
}

# Expanded color constants

const SGR_BR_BLACK = $(sgr_bright_8bit "${SGR_BLACK}")
const SGR_BR_RED = $(sgr_bright_8bit "${SGR_RED}")
const SGR_BR_GREEN = $(sgr_bright_8bit "${SGR_GREEN}")
const SGR_BR_YELLOW = $(sgr_bright_8bit "${SGR_YELLOW}")
const SGR_BR_BLUE = $(sgr_bright_8bit "${SGR_BLUE}")
const SGR_BR_MAGENTA = $(sgr_bright_8bit "${SGR_MAGENTA}")
const SGR_BR_CYAN = $(sgr_bright_8bit "${SGR_CYAN}")
const SGR_BR_WHITE = $(sgr_bright_8bit "${SGR_WHITE}")
pub const BLACK_FG = $(sgr_foreground_3bit "${SGR_BLACK}")
pub const RED_FG = $(sgr_foreground_3bit "${SGR_RED}")
pub const GREEN_FG = $(sgr_foreground_3bit "${SGR_GREEN}")
pub const YELLOW_FG = $(sgr_foreground_3bit "${SGR_YELLOW}")
pub const BLUE_FG = $(sgr_foreground_3bit "${SGR_BLUE}")
pub const MAGENTA_FG = $(sgr_foreground_3bit "${SGR_MAGENTA}")
pub const CYAN_FG = $(sgr_foreground_3bit "${SGR_CYAN}")
pub const WHITE_FG = $(sgr_foreground_3bit "${SGR_WHITE}")
pub const BR_BLACK_FG = $(sgr_foreground_extended "${SGR_BR_BLACK}")
pub const BR_RED_FG = $(sgr_foreground_extended "${SGR_BR_RED}")
pub const BR_GREEN_FG = $(sgr_foreground_extended "${SGR_BR_GREEN}")
pub const BR_YELLOW_FG = $(sgr_foreground_extended "${SGR_BR_YELLOW}")
pub const BR_BLUE_FG = $(sgr_foreground_extended "${SGR_BR_BLUE}")
pub const BR_MAGENTA_FG = $(sgr_foreground_extended "${SGR_BR_MAGENTA}")
pub const BR_CYAN_FG = $(sgr_foreground_extended "${SGR_BR_CYAN}")
pub const BR_WHITE_FG = $(sgr_foreground_extended "${SGR_BR_WHITE}")
pub const BLACK_BG = $(sgr_background_3bit "${SGR_BLACK}")
pub const RED_BG = $(sgr_background_3bit "${SGR_RED}")
pub const GREEN_BG = $(sgr_background_3bit "${SGR_GREEN}")
pub const YELLOW_BG = $(sgr_background_3bit "${SGR_YELLOW}")
pub const BLUE_BG = $(sgr_background_3bit "${SGR_BLUE}")
pub const MAGENTA_BG = $(sgr_background_3bit "${SGR_MAGENTA}")
pub const CYAN_BG = $(sgr_background_3bit "${SGR_CYAN}")
pub const WHITE_BG = $(sgr_background_3bit "${SGR_WHITE}")
pub const BR_BLACK_BG = $(sgr_background_extended "${SGR_BR_BLACK}")
pub const BR_RED_BG = $(sgr_background_extended "${SGR_BR_RED}")
pub const BR_GREEN_BG = $(sgr_background_extended "${SGR_BR_GREEN}")
pub const BR_YELLOW_BG = $(sgr_background_extended "${SGR_BR_YELLOW}")
pub const BR_BLUE_BG = $(sgr_background_extended "${SGR_BR_BLUE}")
pub const BR_MAGENTA_BG = $(sgr_background_extended "${SGR_BR_MAGENTA}")
pub const BR_CYAN_BG = $(sgr_background_extended "${SGR_BR_CYAN}")
pub const BR_WHITE_BG = $(sgr_background_extended "${SGR_BR_WHITE}")

# One of 24 shades of grey
pub fn grey_fg
grey_fg () {
	scope color using sgr_foreground_extended sgr_grey_8bit

	sgr_foreground_extended $(sgr_grey_8bit "$1")

	scope_return
}

pub fn grey_bg
grey_bg () {
	scope color using sgr_background_extended sgr_background_extended

	sgr_background_extended $(sgr_grey_8bit "$1")

	scope_return
}

# 8-bit color
pub fn rgb8_fg
rgb8_fg () {
	scope color using sgr_foreground_extended sgr_color_8bit

	sgr_foreground_extended $(sgr_color_8bit "$1" "$2" "$3")

	scope_return
}

pub fn rgb8_bg
rgb8_bg () {
	scope color using sgr_background_extended sgr_color_8bit

	sgr_background_extended $(sgr_color_8bit "$1" "$2" "$3")

	scope_return
}

# 24-bit color
pub fn rgb24_fg
rgb24_fg () {
	scope color using sgr_foreground_extended sgr_color_24bit

	sgr_foreground_extended $(sgr_color_24bit "$1" "$2" "$3")

	scope_return
}

pub fn rgb24_bg
rgb24_bg () {
	scope color using sgr_background_extended sgr_color_24bit

	sgr_background_extended $(sgr_color_24bit "$1" "$2" "$3")

	scope_return
}

# Multiple fonts from [0..10)
pub fn font
font () {
	expr "$1" + "10"
}

# Apply a set of styles
pub fn style
style () {
	scope color using sgr_escape

	full_style=""
	for style in $@; do
		full_style="${full_style};${style}"
	done

	sgr_escape "${full_style#;}"

	scope_return
}

# Reset all styles
pub fn unstyle
unstyle () {
	scope color using sgr_reset
	sgr_reset
	scope_return
}

# Apply a set of styles to a span of text
pub fn span
span () {
	scope

	var full_style = ""
	while [ "$#" -gt "1" ]; do
		full_style="${full_style};$1"; shift
	done

	printf "\033[%sm" "${full_style#;}"
	printf "%s" "$*"
	printf "\033[0m"

	scope_return
}

end_module
