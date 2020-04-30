#!/bin/sh
set -e

which import 2&>1 > /dev/null \
		|| source <(curl -Ls https://xurtis.pw/import/import.sh)

run import-install
