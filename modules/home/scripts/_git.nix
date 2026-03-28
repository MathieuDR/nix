{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "get-diff" ''
      if [ -z "$1" ]; then
          echo "Usage: $0 <base-branch>"
          exit 1
      fi

      BASE_BRANCH="origin/$1"
      CURRENT_BRANCH=$(${pkgs.git}/bin/git branch --show-current)

      if [ -z "$CURRENT_BRANCH" ]; then
          echo "No branch is currently checked out."
          exit 1
      fi

      git fetch origin

      LOCAL_COMMITS=$(${pkgs.git}/bin/git rev-list HEAD..origin/"$CURRENT_BRANCH" --count)
      REMOTE_COMMITS=$(${pkgs.git}/bin/git rev-list origin/"$CURRENT_BRANCH"..HEAD --count)

      if [ "$LOCAL_COMMITS" -gt 0 ]; then
          echo "Error: There are commits on the remote branch that you do not have locally. Please pull the latest changes."
          exit 1
      fi

      if [ "$REMOTE_COMMITS" -gt 0 ]; then
          echo "Error: There are local commits that have not been pushed to the remote branch. Please push your changes."
          exit 1
      fi

      MERGE_BASE=$(${pkgs.git}/bin/git merge-base "$BASE_BRANCH" "$CURRENT_BRANCH")

      ${pkgs.git}/bin/git diff --name-only "$MERGE_BASE"..."$CURRENT_BRANCH" | while read -r file; do
          echo "File: $file"
          echo "Diff:"
          ${pkgs.git}/bin/git diff "$MERGE_BASE"..."$CURRENT_BRANCH" -- "$file"
          echo
      done
    '')

    (pkgs.writeShellScriptBin "list_files_and_contents" ''
      if [ -z "$1" ]; then
        echo "Please provide a directory path."
        exit 1
      fi

      cd "$1" || exit 1

      ${pkgs.git}/bin/git ls-files --others --exclude-standard --cached | while read -r file; do
        if [[ "$file" == *.crt ]]; then
          echo "Skipping .crt file: $file"
          echo
          continue
        fi

        mime_type=$(${pkgs.file}/bin/file --mime-type -b "$file")
        if [[ "$mime_type" == text/* || "$mime_type" == application/json ]]; then
          echo "./$file"
          echo "----------------"
          cat "$file"
          echo
        else
          echo "Skipping non-text file: $file"
          echo
        fi
      done
    '')
  ];
}
