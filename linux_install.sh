#!/bin/bash

# Get the provided Python file name as an argument
py_file="esobinv2.py"

# Check if the provided Python file exists
if [ ! -f "$py_file" ]; then
    echo "File '$py_file' not found!"
    exit 1
fi

# Create the compiled directory if it doesn't exist
compiled_dir="compiled"
if [ ! -d "$compiled_dir" ]; then
    mkdir "$compiled_dir"
fi

# Create the bin directory inside compiled if it doesn't exist
bin_dir="$compiled_dir/bin"
if [ ! -d "$bin_dir" ]; then
    mkdir "$bin_dir"
fi

# Compile the Python file to a .pyc file
python -m py_compile "$py_file"

# Extract the directory path and module name from the Python file
dir_path=$(dirname "$py_file")
module_name=$(basename "${py_file%.py}")

# Find the compiled .pyc file
compiled_file=$(find "$dir_path/__pycache__" -type f -name "${module_name}.*.pyc" -print -quit)

# Check if the compiled .pyc file exists
if [ -f "$compiled_file" ]; then
    # Remove the .pyc extension from the file
    mv "$compiled_file" "${dir_path}/${module_name}"
    echo "Executable file '${module_name}' created."

    # Move the executable to compiled/bin
    mv "${dir_path}/${module_name}" "$bin_dir/"
    echo "Executable file moved to 'compiled/bin/'."
    # Make the compiled file executable
    chmod +x "${bin_dir}/${module_name}"
else
    echo "Compiled file for '${py_file}' not found in __pycache__ directory."
    exit 1
fi
