#!/bin/sh

show_vars() {
	# No new scope here
	printf "$1: x = %s, y = %s, z = %s\n" \
		"${x-UNDEFINED}" \
		"${y-UNDEFINED}" \
		"${z-UNDEFINED}"
	# set | grep '^__module_SCOPE'
	# echo
}

func1 () {
	scope

	var x = 12;
	var z = 14;

	show_vars func1
	func2
	show_vars func1

	end_scope
}

func2 () {
	scope

	var x = 22;
	var y = 23;

	show_vars func2
	func3
	show_vars func2
	func3
	show_vars func2

	end_scope
}

func3 () {
	scope
	var x = 32;

	show_vars func3

	scope_return
}
