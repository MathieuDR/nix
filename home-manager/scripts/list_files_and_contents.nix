{pkgs}:
pkgs.writeShellScriptBin "list_files_and_contents" ''
  #!/usr/bin/env bash

  # Call with different mimetypes
  # ALLOWED_MIME_TYPES="text/*,application/json" list_files_and_contents.sh .

  # Default allowed MIME types
  ALLOWED_MIME_TYPES=${ALLOWED_MIME_TYPES:-"text/*,application/json,application/javascript,application/xml"}

  # Check if directory is passed as an argument
  if [ -z "$1" ]; then
    echo "Please provide a directory path."
    exit 1
  fi

  # Change to the specified directory
  cd "$1" || exit 1

  # Convert allowed MIME types to an array for easier checking
  IFS=',' read -r -a mime_types <<< "$ALLOWED_MIME_TYPES"

  # Function to check if a MIME type is allowed
  is_allowed_mime_type() {
    local mime=$1
    for allowed_mime in "${mime_types[@]}"; do
      if [[ "$mime" == "$allowed_mime" || "$mime" == "${allowed_mime%/*}/*" ]]; then
        return 0
      fi
    done
    return 1
  }

  # Use git ls-files to get files tracked by git and those that match .gitignore rules
  ${pkgs.git}/bin/git ls-files --others --exclude-standard --cached | while read -r file; do
    # Skip .crt files explicitly
    if [[ "$file" == *.crt ]]; then
      echo "Skipping .crt file: $file"
      echo
      continue
    fi

    # Get MIME type of the file
    mime_type=$(${pkgs.file}/bin/file --mime-type -b "$file")

    # Check if the file MIME type is allowed
    if is_allowed_mime_type "$mime_type"; then
      echo "./$file"         # Output the file path
      echo "----------------" # Separator for readability
      cat "$file"            # Output the file content
      echo                   # Add an empty line between files
    else
      echo "Skipping non-text file: $file"
      echo
    fi
  done
''
