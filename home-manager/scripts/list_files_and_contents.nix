{pkgs}:
pkgs.writeShellScriptBin "list_files_and_contents" ''
  #!/usr/bin/env bash

  if [ -z "$1" ]; then
    echo "Please provide a directory path."
    exit 1
  fi

  # Iterate over each file in the specified directory recursively
  find "$1" -type f | while read -r file; do
    echo "$file"           # Output the file path
    echo "----------------" # Separator for readability
    cat "$file"            # Output the file content
    echo                   # Add an empty line between files
  done
''
