#!/bin/sh
set -e

import import_tools
import color using span BOLD

echo -n "Installing $(span $BOLD "${IMPORT_GITHUB_BASE}") "
echo    "to $(span $BOLD "${IMPORT_INSTALL_LOCATION}")"

update_import

cat <<__END
To use a local copy of import add the following line to your init script:

$(span $BOLD "echo ${IMPORT_INIT} && . ${IMPORT_INIT}")

You may wish to run that command now
__END
