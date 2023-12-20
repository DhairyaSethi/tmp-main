#!/bin/bash -e

replace_pragma_solidity() {
  local file=$1
  local version=$2
  local temp_file=$(mktemp)
  awk -v version="$version" '/^pragma solidity/ {print "pragma solidity " version ";"; next} 1' "$file" > "$temp_file"
  mv "$temp_file" "$file"
}

process_sol_files() {
  local directory=$1
  local version=$2
  find "$directory" -type f -name "*.sol" | while read -r file; do
    echo "Updating $file"
    replace_pragma_solidity "$file" "$version"
  done
}

process_sol_files tmp/interfaces ">=0.6.2 <0.9.0"
