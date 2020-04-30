#!/bin/sh
set -e

import import-tools
import color

echo -n "Installing $(span $BOLD "${IMPORT_GITHUB_BASE}") "
echo    "to $(span $BOLD "${IMPORT_INSTALL_LOCATION}")"

update_import

cat <<__END
To use a local copy of import add the following line to your init script:

$(span $BOLD "source ${IMPORT_INIT}")
__END
