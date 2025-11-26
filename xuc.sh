#!/usr/bin/env bash

# xuc.sh - Detect a file’s compression type and run the correct decompression command with arguments (name: uncompress any file: x uncompress)

set -o errexit # stop script from resuming after error (default shell behaviour is to happily continue after an error has occured - same as set -e).
set -o nounset # stop script if a variable has not been set (default shell behaviour is to treat unset variables as empty strings ("") - same as set -u).
set -o pipefail # set the exit code to the code of the last (rightmost) command in the pipeline, or to zero if all commands in the pipeline execute successfully.

# Enable debug mode by running script as TRACE=1 ./xuc.sh file_to_decompress
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

# Exactly one argument (the name of the file to decompress) required.
if [[ "$#" != 1 ]]; then
    echo "Usage: ./xuc.sh file_to_uncompress"
    exit 1
fi

# Ensure arg refers to an actual file
file_to_decompress="$1"
if [[ ! -e "$file_to_decompress" ]]; then
    echo "'$file_to_decompress' is not a file...exiting"
    exit 1
fi

# Common compression formats supported: 7-zip, XZ, Zip, Zstandard, bzip2, gzip, tar
# Note: 7-zip is not a part of the standard Unix/Linux compression suite but it is extensively used and usually installed manually
# Hashmaps are called associative arrays in Bash and are only available in Bash 4.0 or later
# This is the hashmap (type_program_args_map) whose keys are file_type and values are arrays `decompression_program`s and their arguments
declare -A type_program_args_map=(
    ["7-zip"]="7z x"
    ["XZ"]="xz -d"
    ["Zip"]="unzip"
    ["Zstandard"]="zstd -d"
    ["bzip2"]="bzip2 -d"
    ["gzip"]="gzip -d"
    ["tar"]="tar -xf"
)

# Detect compression type by matching `file` output against known keys.
# Split the keys in type_program_args_map by new line ('\n') and feed to grep
# The file_type of the file (file_to_decompress) is determined by the `file` utility
# Finally, assign to `file_type` variable through command substitution 
file_type=$(file --brief "$file_to_decompress" | grep \
    --only-matching \
    --word-regexp \
    --fixed-strings \
    --file=<(printf "%s\n" "${!type_program_args_map[@]}"))

# Check for unknown format (file/grep combination above returned an empty string)
if [[ -z "$file_type" ]]; then
    echo "Unknown compression type for '$file_to_decompress'"
    exit 1
fi

# Extract decompression_program and optional arg
# The values of `type_program_args_map` are read into `prog_args` keyed by `file_type` selected above
read -r decompression_program arg <<< "${type_program_args_map[$file_type]}"

# Check if decompression_program exists
if ! command -v "$decompression_program" >/dev/null; then
    echo "Cannot uncompress '$file_to_decompress', $decompression_program not found"
    exit 1
else
    # arg might be empty in cases like unzip
    if [[ -n "$arg" ]]; then
	"$decompression_program" "$arg" "$file_to_decompress"
    else
	"$decompression_program" "$file_to_decompress"
    fi
fi
