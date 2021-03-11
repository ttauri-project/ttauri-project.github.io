#!/bin/bash

TAGS=$(<ttauri_versions.txt)

for TAG in ${TAGS}
do
  echo "Checking out version: $TAG"

  (cd ttauri; git checkout -q "${TAG}")

  if [[ $TAG == v* ]];
  then
    VER="${TAG:1}"
  else
    VER=$TAG
  fi

  echo "Environment variables used by Doxygen config:"
  export TTAURI_TAG="${TAG}"
  export TTAURI_VERSION="${VER}"
  echo "TTAURI_TAG     -> $TTAURI_TAG"
  echo "TTAURI_VERSION -> $TTAURI_VERSION"

  mkdir -p "docs/ttauri/${TTAURI_VERSION}"

  echo " - [${TTAURI_VERSION}](ttauri/${TTAURI_VERSION})" >> scripts/docs_readme.md

  echo "Current working dir: $PWD"

  doxygen scripts/Doxyfile

done