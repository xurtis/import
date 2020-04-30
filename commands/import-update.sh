#!/bin/sh
set -e

import import-tools
import color

echo -n "Updating $(span $BOLD "${IMPORT_INSTALL_LOCATION}") "
echo    "from $(span $BOLD "${IMPORT_GITHUB_BASE}")"

update_import
