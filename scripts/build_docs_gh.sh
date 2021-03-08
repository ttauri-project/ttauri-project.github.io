#!/bin/bash

TAGS=$(<ttauri_versions.txt)

for TAG in ${TAGS}
do
  echo "Checking out version: $TAG"

  git checkout -q $TAG

  if [[ $TAG == v* ]];
  then
    VER="${TAG:1}"
  else
    VER=$TAG
  fi

  mkdir -p "docs/ttauri/${VER}"

  echo "Setting environment vars for doxygen config:"
  export TTAURI_TAG="${TAG}"
  export TTAURI_VERSION="${VER}"

  echo "TTAURI_TAG     -> $TTAURI_TAG"
  echo "TTAURI_VERSION -> $TTAURI_VERSION"

  echo "Current working dir: $PWD"

  doxygen scripts/Doxyfile

done