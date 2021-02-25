#!/bin/bash

DOXYGEN="/Applications/Doxygen.app/Contents/Resources/doxygen"

if [ ! -e ttauri_versions.txt ]
then
    echo "This script should be run from the same directory that contains ttauri_versions.txt"
    exit 2
fi

VERSIONS=`cat ttauri_versions.txt`

TTAURI_DIR="ttauri"
git clone https://github.com/ttauri-project/ttauri.git "${TTAURI_DIR}"

for VERSION in ${VERSIONS}
do
    echo "Checkout out version ${VERSION} of ttauri."
    (cd "${TTAURI_DIR}"; git checkout -q "${VERSION}")

    mkdir -p "documentation/ttauri/${VERSION}"

    TTAURI_DIR="${TTAURI_DIR}" TTAURI_VERSION="$VERSION" "$DOXYGEN"
done

rm -fr ${TTAURI_DIR}

