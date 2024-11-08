{pkgs}:
pkgs.writeShellScriptBin "list_files_and_contents" ''
  #!/usr/bin/env bash

  # Check if directory is passed as an argument
  if [ -z "$1" ]; then
    echo "Please provide a directory path."
    exit 1
  fi

  # Change to the specified directory
  cd "$1" || exit 1

  # Use git ls-files to get files tracked by git and those that match .gitignore rules
  ${pkgs.git}/bin/git ls-files --others --exclude-standard --cached | while read -r file; do
    # Skip .crt files explicitly
    if [[ "$file" == *.crt ]]; then
      echo "Skipping .crt file: $file"
      echo
      continue
    fi

    # Check if the file is a text-based file or JSON by MIME type
    mime_type=$(${pkgs.file}/bin/file --mime-type -b "$file")
    if [[ "$mime_type" == text/* || "$mime_type" == application/json ]]; then
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
