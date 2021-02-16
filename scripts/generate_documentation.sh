#!/bin/bash

DOXYGEN="/Applications/Doxygen.app/Contents/Resources/doxygen"

if [ ! -e ttauri_versions.txt ]
then
    echo "This script should be run from the same directory that contains ttauri_versions.txt"
    exit 2
fi

VERSIONS=`cat ttauri_versions.txt`

git submodule init
git submodule update

for VERSION in $VERSIONS
do
    echo "Checkout out version $VERSION of ttauri."
    (cd ttauri; git checkout -q "$VERSION")

    mkdir -p "documentation/ttauri/$VERSION"

    TTAURI_VERSION="$VERSION" "$DOXYGEN"
done

