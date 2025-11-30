#!/bin/bash

# Directory containing files
dir="/path/to/the/directory"

# Loop through all files in the directory
shopt -s nullglob
for file in "$dir"/*; do
  # Check if it's a regular file
  [ -f "$file" ] || continue

  # Extract filename and directory separately
  filename=$(basename -- "$file")
  dirname=$(dirname -- "$file")

  # Remove trailing [text] before the extension
  # Separate base and extension
  base="${filename%.*}"
  ext="${filename##*.}"

  # If no extension, ext will be same as filename, so check that
  if [[ "$base" == "$filename" ]]; then
    ext=""
  else
    ext=".$ext"
  fi

  # Remove trailing bracketed text from base name
  # This removes the last occurrence of '[' and everything after it
  newbase="${base%[*}"

  # Remove trailing whitespace from newbase
  newbase="${newbase%"${newbase##*[![:space:]]}"}"

  # Construct new filename
  newname="$newbase$ext"

  # If the new name is different, rename the file
  if [[ "$filename" != "$newname" ]]; then
    # Check if target file exists
    if [[ -e "$dirname/$newname" ]]; then
      echo "Cannot rename '$filename' to '$newname': target already exists."
    else
      echo "Renaming '$filename' -> '$newname'"
      mv -- "$file" "$dirname/$newname"
    fi
  fi
done
