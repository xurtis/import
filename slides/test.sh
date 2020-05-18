#!/usr/bin/dash

# Set up import
_="${0%/*}/../local-init.sh"
. "${0%/*}/../local-init.sh"

import slides using slide present

slide <<- __slide
	fin
__slide

present
