#!/bin/sh

# General utility functions

# Produces the last argument in its list of arguments
last () {
	eval "echo \"\$$#\""
}
