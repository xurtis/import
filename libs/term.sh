#!/bin/sh

# Module for terminal control

module "term"

pub fn move_absolute
move_absolute () {
	tput cup "$@"
}

pub fn move_line_absolute
move_line_absolute () {
	printf "\033[%dG" "$@"
}

pub fn clear_display
clear_display () {
	tput clear
}

pub fn clear_line
clear_line () {
	printf "\033[2K"
}


end_module
