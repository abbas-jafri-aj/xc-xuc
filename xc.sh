#!/usr/bin/env bash

# xc.sh - Detect a file’s extension and run the correct compression command with arguments (name: compress any file: x compress)

set -o errexit # stop script from resuming after error (default shell behaviour is to happily continue after an error has occured - same as set -e).
set -o nounset # stop script if a variable has not been set (default shell behaviour is to treat unset variables as empty strings ("") - same as set -u).
set -o pipefail # set the exit code to the code of the last (rightmost) command in the pipeline, or to zero if all commands in the pipeline execute successfully.

# Enable debug mode by running script as TRACE=1 ./xuc.sh file_to_decompress
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

# Exactly two arguments (the name of the file to decompress) required.
if [[ "$#" != 2 ]]; then
    echo "Usage: ./xuc.sh source target.ext"
    exit 1
fi

# Ensure source refers to an actual file
file_to_compress="$1"
if [[ ! -e "$file_to_compress" ]]; then
    echo "'$file_to_compress' is not a file...exiting"
    exit 1
fi

# Ensure target file does not exist
target_compressed_file="$2"
if [[ -e "$target_compressed_file" ]]; then
    echo "'$target_compressed_file' already exists...exiting"
    exit 1
fi

# Common compression formats supported: 7-zip, XZ, Zip, Zstandard, bzip2, gzip, tar
# Note: 7-zip is not a part of the standard Unix/Linux compression suite but it is extensively used and usually installed manually
# Hashmaps are called associative arrays in Bash and are only available in Bash 4.0 or later
# This is the hashmap (extension_program_args_map) whose keys are extensions and values are arrays `compression_program`s and their arguments
declare -A extension_program_args_map=(
    ["7z"]="7z a"
    ["xz"]="xz -d"
    ["zip"]="zip"
    ["zst"]="zstd -d"
    ["bzip2"]="bzip2 -d"
    ["gzip"]="gzip -d"
    ["tar"]="tar -cf"
)

# Extract `extension` from the `target_compressed_file`
extension="${target_compressed_file##*.}"
# Look for `extension` in keys of `extension_program_args_map` and assign to `matched_extension` through command substitution 
matched_extension=$(echo "${!extension_program_args_map[@]}" | grep --only-matching --word-regexp --fixed-strings $extension)

# If nothing found, the target file format is not supported (grep returned an empty string)
if [[ -z "$matched_extension" ]]; then
    echo "Unknown compression type 'matched_extension' in '$target_compressed_file'"
    exit 1
fi

# Extract compression_program and optional arg
# The values of `extension_program_args_map` are read into `prog_args` keyed by `matched_extension` selected above
read -r compression_program arg <<< "${extension_program_args_map[$matched_extension]}"

# Check if compression_program exists
if ! command -v "$compression_program" >/dev/null; then
    echo "Cannot compress '$file_to_compress', $compression_program not found"
    exit 1
else
    # arg might be empty in cases like unzip
    if [[ -n "$arg" ]]; then
	echo "$compression_program" "$arg" "$file_to_compress" "target_compressed_file"
    else
	echo "$compression_program" "$file_to_compress" "target_compressed_file"
    fi
fi
