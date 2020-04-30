#!/bin/sh

# Tools for working with a local install of `import`

# Location of current tarball
IMPORT_GITHUB_URL="https://github.com/xurtis/import/archive/master.tar.gz"

# Get data for the current user
IMPORT_UID=$(id -u)
IMPORT_USER=$(getent passwd ${IMPORT_UID} | cut -d ':' -f 1)
IMPORT_HOME=$(getent passwd ${IMPORT_UID} | cut -d ':' -f 6)

# Ensure the install directory exists
IMPORT_INSTALL_LOCATION="${IMPORT_HOME}/.shell-import"
mkdir -p "${IMPORT_INSTALL_LOCATION}"

# Location to store the update file when installing
IMPORT_UPDATE_LOCATION="${IMPORT_INSTALL_LOCATION}/update.tar.gz"

IMPORT_INIT="${IMPORT_INSTALL_LOCATION}/local-init.sh"

update_import () {
	# Download the update
	curl -fLs -o "${IMPORT_UPDATE_LOCATION}" "${IMPORT_GITHUB_URL}"

	# Extract the update
	tar -x \
		-C "${IMPORT_INSTALL_LOCATION}" \
		-f "${IMPORT_UPDATE_LOCATION}" \
		--strip-components 1

	source "${IMPORT_INIT}"
}
