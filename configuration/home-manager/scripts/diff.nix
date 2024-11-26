{pkgs}:
pkgs.writeShellScriptBin "get-diff" ''
  	# Check if the base branch argument is provided
  if [ -z "$1" ]; then
      echo "Usage: $0 <base-branch>"
      exit 1
  fi

  # Variables
  BASE_BRANCH="origin/$1"
  CURRENT_BRANCH=$(${pkgs.git}/bin/git branch --show-current)

  # Check if we're on a valid branch
  if [ -z "$CURRENT_BRANCH" ]; then
      echo "No branch is currently checked out."
      exit 1
  fi

  # Fetch latest changes
  git fetch origin

  # Check if local branch is up to date with remote
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

  # Find the merge base
  MERGE_BASE=$(${pkgs.git}/bin/git merge-base "$BASE_BRANCH" "$CURRENT_BRANCH")

  # Output diffs for all affected files
  ${pkgs.git}/bin/git diff --name-only "$MERGE_BASE"..."$CURRENT_BRANCH" | while read -r file; do
      echo "File: $file"
      echo "Diff:"
      ${pkgs.git}/bin/git diff "$MERGE_BASE"..."$CURRENT_BRANCH" -- "$file"
      echo
  done
''
