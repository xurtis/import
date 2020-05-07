#!/bin/sh
set -e

import import_tools
import color using span BOLD ITALIC

echo -n "Updating $(span $BOLD "${IMPORT_INSTALL_LOCATION}") "
echo    "from $(span $BOLD "${IMPORT_GITHUB_BASE}")"

update_import

cat <<__END
You may wish to run $(span $BOLD "import_refresh") to load the latest \
version of the $(span $ITALIC "import") and $(span $ITALIC "run") \
commands.
__END
