#!/bin/sh
set -e

import import-tools
import color
update_import

cat <<__END
To use a local copy of import add the following line to your init script
or a script using import:

$(span $BOLD "which import 2&>1 > /dev/null || source ${IMPORT_INIT}")
__END
