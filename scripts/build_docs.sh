#!/bin/bash

rm -fr ttauri
git clone https://github.com/ttauri-project/ttauri.git ttauri

cd ttauri
(echo "main" && git tag -l --sort=-version:refname "v*") > ../versions.txt
git tag --sort=committerdate | tail -1 | cut -c2- > ../latest_version.txt

echo "Latest Version:"
cat ../latest_version.txt

TAGS=$(<../versions.txt)
echo -e "Available versions:\n$TAGS"

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

  mkdir -p "../docs/ttauri/${VER}"

  echo "Setting environment vars for doxygen config:"
  export TTAURI_TAG="${TAG}"
  export TTAURI_VERSION="${VER}"

  echo "TTAURI_TAG     -> $TTAURI_TAG"
  echo "TTAURI_VERSION -> $TTAURI_VERSION"

  echo "Current working dir: $PWD"

  doxygen "../scripts/Doxyfile"
done