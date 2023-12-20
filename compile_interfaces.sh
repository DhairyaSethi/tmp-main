#!/bin/bash -e

rm -rf tmp/ # alt: mktemp -d
mkdir -p tmp/interfaces

replace_pragma_solidity() {
  local file=$1
  local version=$2
  local temp_file=$(mktemp)
  awk -v version="$version" '/^pragma solidity/ {print "pragma solidity " version ";"; next} 1' "$file" > "$temp_file"
  mv "$temp_file" "$file"
}

compile_and_flatten() {
  local source_path=$1
  local project=$2
  local subpath=$3
  local project_type=$4

  local input_dir="$source_path/$project/$subpath"

  local output_dir="tmp/interfaces/$project"

  local flatten_command="forge flatten"
  
  if [ "$project_type" == "hardhat" ]; then
    nvm use || true
    cd "$source_path/$project"
    npm i 
    cd -
    flatten_command+=" --lib-paths node_modules"
  fi

  echo "processing $project"
  echo ""

  find "$input_dir" -type f -name "*.sol" | while read -r sol_file; do
    relative_path=$(echo "$sol_file" | sed -E "s|$input_dir||")
    output_file="$output_dir$relative_path"

    echo "flattening $sol_file"
    $flatten_command "$sol_file" -o "$output_file"
    replace_pragma_solidity "$output_file" ">=0.6.2 <0.9.0"
  done

  echo ""
}

copy_interfaces() {
  local source_path=$1
  local subpath=$2
  local project_type=$3

  declare -a projects=("${@:4}")

  for project in "${projects[@]}"; do
    compile_and_flatten "$source_path" "$project" "$subpath" "$project_type"
  done
}

# packages
declare -a pkgs=($(ls src/pkgs))
copy_interfaces "src/pkgs" "interface" "forge" "${pkgs[@]}"

# libs which follow src/interface pattern
declare -a src_libs=("staking-hub")
copy_interfaces "lib" "src/interface" "forge" "${src_libs[@]}"

# libs which follow contracts/interfaces pattern
declare -a contracts_libs=("core-contracts")
copy_interfaces "lib" "contracts/interfaces" "hardhat" "${contracts_libs[@]}"
