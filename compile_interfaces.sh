#!/bin/bash -e

rm -rf tmp/ # alt: mktemp -d
mkdir -p tmp/interfaces

copy_interfaces() {
  local source_path=$1
  local subpath=$2

  declare -a items=("${@:3}")

  for item in "${items[@]}"; do
    cp -r "$source_path/$item/$subpath/" "tmp/interfaces/$item/"
  done
}

# packages
declare -a pkgs=($(ls src/pkgs))
copy_interfaces "src/pkgs" "interface" "${pkgs[@]}"

# libs which follow src/interface pattern
declare -a src_libs=("staking-hub")
copy_interfaces "lib" "src/interface" "${src_libs[@]}"

# libs which follow contracts/interfaces pattern
declare -a contracts_libs=("core-contracts")
copy_interfaces "lib" "contracts/interfaces" "${contracts_libs[@]}"
