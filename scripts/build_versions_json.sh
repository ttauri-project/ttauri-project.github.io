#!/bin/bash

echo "Current working dir: $PWD"

cat ../ttauri_versions.txt | jq -Rsc 'split("\n") | map(select(. != ""))' | jq ' { versions: [.]|ltrimstr("v") } ' > ttauri_versions.json
cat ttauri_versions.json

cat ../ttauri_latest_version.txt | jq -Rsc 'split("\n") | map(select(. != ""))' | jq ' { latest_version: .[]|ltrimstr("v") } ' > ttauri_latest_version.json
cat ttauri_latest_version.json

jq -s ' .[0] + .[1]' ttauri_latest_version.json ttauri_versions.json > ../versions.json
jq -c '{ttauri: { latest_version: .latest_version, versions: .versions[] } }' ../versions.json

rm ../ttauri_versions.txt ../ttauri_latest_version.txt
rm ttauri_versions.json ttauri_latest_version.json

echo "versions.json:"
cat ../versions.json