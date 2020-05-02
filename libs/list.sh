#!/bin/sh

# Simple library for manipulating lists encoded in strings

# All but the last element in the list
list_start () {
	__list_separator=$1; shift
	__list_contents=$1; shift

	echo "${__list_contents%${__list_separator}*}"

	unset __list_separator
	unset __list_contents
}

# The last element of the list
list_last () {
	__list_separator=$1; shift
	__list_contents=$1; shift

	echo "${__list_contents##*${__list_separator}}"

	unset __list_separator
	unset __list_contents
}

list_push () {
	__list_separator=$1; shift
	__list_contents=$1; shift
	__list_pushed=$1; shift

	echo "${__list_contents}${__list_separator}${__list_pushed}"

	unset __list_separator
	unset __list_pushed
}

list_foreach () {
	__list_separator=$1; shift
	__list_contents=$1; shift

	while ! list_empty "${__list_contents}"; do
		__list_element=$(list_last "${__list_separator}" "${__list_contents}")
		__list_contents=$(list_start "${__list_separator}" "${__list_contents}")
		"$@" "${__list_element}"
		unset __list_element
	done

	unset __list_separator
	unset __list_contents
}

list_empty () {
	test "${#1}" -eq 0
}
