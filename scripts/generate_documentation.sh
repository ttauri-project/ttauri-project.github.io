#!/bin/bash

DOXYGEN="/Applications/Doxygen.app/Contents/Resources/doxygen"

if [ ! -e ttauri_versions.txt ]
then
    echo "This script should be run from the same directory that contains ttauri_versions.txt"
    exit 2
fi

TAGS=`cat ttauri_versions.txt`

TTAURI_DIR="ttauri"
if [ ! -e ${TTAURI_DIR} ]
then
    git clone https://github.com/ttauri-project/ttauri.git "${TTAURI_DIR}"
fi

for TAG in ${TAGS}
do
    echo "Checkout out version ${TAG} of ttauri."
    (cd "${TTAURI_DIR}"; git checkout -q "${TAG}")

    mkdir -p "documentation/ttauri/${TAG}"

    TAG_SELECT=""
    for T in ${TAGS}
    do
        if [ "${T}" = "${TAG}" ]
        then
            TAG_SELECT="${TAG_SELECT} *${T}"
        else
            TAG_SELECT="${TAG_SELECT} ${T}"
        fi
    done

    TTAURI_DIR="${TTAURI_DIR}" TTAURI_TAG="${TAG}" TTAURI_TAG_SELECT="${TAG_SELECT}" "${DOXYGEN}" "scripts/Doxyfile"
done

rm -fr ${TTAURI_DIR}

