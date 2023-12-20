#!/bin/bash -e

rm -rf tmp/ # alt: mktemp -d
mkdir -p tmp/interfaces

declare -a pkgs=($(ls src/pkgs))

for pkg in "${pkgs[@]}"; do
  cp -r src/pkgs/$pkg/interface/ tmp/interfaces/$pkg/
done

# libs which follow src/interface pattern
declare -a libs=("staking-hub")

for pkg in "${libs[@]}"; do
  cp -r lib/$pkg/src/interface/ tmp/interfaces/$pkg/
done

# libs which follow contracts/interfaces pattern
declare -a libs=("core-contracts")

for pkg in "${libs[@]}"; do
  cp -r lib/$pkg/contracts/interfaces/ tmp/interfaces/$pkg/
done
