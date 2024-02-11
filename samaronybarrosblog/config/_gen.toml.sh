#!/bin/bash

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1.toml> [<file2.toml> ...]"
    exit 1
fi

# Specify the output file name
output_file="../hugo.toml"

# Use cat to concatenate all provided .toml files and redirect the output to the specified file
cat "$@" > "$output_file"

echo "Combined .toml files into $output_file"
