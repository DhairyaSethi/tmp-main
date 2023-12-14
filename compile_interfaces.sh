#!/bin/bash -e

rm -rf tmp/ # alt: mktemp -d
mkdir -p tmp/interfaces

declare -a pkgs=($(ls src/pkgs))

for pkg in "${pkgs[@]}"; do
  cp -r src/pkgs/$pkg/interface/ tmp/interfaces/$pkg/
done
