{...}: {
  flake.modules.homeManager.fish = {
    pkgs,
    lib,
    ...
  }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';

      functions = {
        fish_title = {
          description = "Set terminal title with smart path formatting";
          body = ''
            set -l cmd_line $argv[1]
            set -l current_dir (pwd)
            set -l path_parts (string split "/" $current_dir)
            set -l num_parts (count $path_parts)
            set -l formatted_path

            if test "$current_dir" = "$HOME"
              set formatted_path "~"
            else if string match -q "$HOME/*" $current_dir
              set -l rel_path (string replace "$HOME/" "" $current_dir)
              set -l rel_parts (string split "/" $rel_path)
              set -l rel_count (count $rel_parts)
              if test $rel_count -le 2
                set formatted_path "~/"(string join "/" -- $rel_parts)
              else
                set formatted_path "~/../"(string join "/" -- $rel_parts[-2..-1])
              end
            else
              if test $num_parts -le 3
                set formatted_path (string join "/" -- $path_parts)
              else
                set formatted_path "../"(string join "/" -- $path_parts[-2..-1])
              end
            end

            if test -n "$cmd_line"
              set -l cmd_parts (string split " " $cmd_line)
              if test (count $cmd_parts) -gt 1
                echo "$cmd_parts[1] $cmd_parts[2]"
              else
                echo "$cmd_parts[1] $formatted_path"
              end
            else
              echo "$formatted_path"
            end
          '';
        };

        frontmatter = {
          description = "Extract YAML frontmatter from a markdown file";
          argumentNames = ["file"];
          body = ''
            if test -z "$argv[1]"
              echo "Usage: frontmatter <file.md>"
              return 1
            end
            sed -n '1,/^---$/{ /^---$/d; p }' $argv[1]
          '';
        };

        multi_frontmatter = {
          description = "Aggregate frontmatter from markdown files. Accepts piped files or a directory path.";
          body = ''
            set -l recursive false
            set -l dir ""

            for arg in $argv
              switch $arg
                case -r --recursive
                  set recursive true
                case '*'
                  set dir $arg
              end
            end

            set -l files
            if not isatty stdin
              while read -l line
                set -a files $line
              end
            else if test -n "$dir"
              if $recursive
                set files (${pkgs.fd}/bin/fd --type f '\.md$' $dir)
              else
                set files (${pkgs.fd}/bin/fd --type f '\.md$' --max-depth 1 $dir)
              end
            else
              echo "Usage: multi_frontmatter [-r] [dir_path]"
              echo "       fd '\.md\$' | multi_frontmatter"
              return 1
            end

            for f in $files
              frontmatter $f
              echo "---"
            end | ${pkgs.yq-go}/bin/yq ea '[.]'
          '';
        };

        gfp = {
          description = "Git fetch and pull";
          body = ''
            git fetch --prune && git pull
          '';
        };

        gsw = {
          description = "Interactively switch git branches with fzf";
          argumentNames = ["scope"];
          body = ''
            switch $argv[1]
                case a all
                    set branch_flag "-a"
                case r remote
                    set branch_flag "-r"
            end

            git branch $branch_flag --color=always | \
              grep -v HEAD | \
              sed 's/\(remotes\/\)\?origin\//> /' | \
              sed 's/^[[:space:]]*//' | \
              sort -u | \
              fzf --ansi --preview 'git log --oneline --graph --date=short --color=always -20 {}' | \
              xargs git switch
          '';
        };

        gnb = {
          description = "Create new git branch and push to origin";
          argumentNames = ["branch_name"];
          body = ''
            if test -z "$argv[1]"
              echo "Usage: gnb <branch_name>"
              return 1
            end

            git checkout -b $argv[1]
            or begin
              echo "Failed to checkout to branch $argv[1]"
              return 1
            end

            git push -u origin $argv[1]
            or begin
              echo "Failed to push the branch $argv[1] to origin"
              return 1
            end

            echo "Successfully checked out to and pushed $argv[1]"
          '';
        };

        open = {
          description = "Open files with default application";
          body = ''
            xdg-open $argv
          '';
        };
      };

      shellAbbrs = {
        ":qa" = "exit";
        ":wq" = "exit";
        ":q" = "exit";

        g = "git";
        gs = "git status";
        gswm = "git switch main";
        gswt = "git switch -";
        gd = "git diff";
        ga = "git add";
        gap = "git add -p";
        gc = {
          expansion = "git commit -m \"%\"";
          setCursor = true;
        };
        gca = "git commit --amend";
        gco = "git checkout";
        gl = "git log --oneline --graph --decorate";
        gp = "git push";
        gpfo = "git push --force-with-lease";
        gpr = "gh pr new";
        gvpr = "gh pr view --web";
        grc = "git rebase --continue";

        ntags = "fd -e md | multi_frontmatter | yq ea '.[].tags[]' | grep -v -e '^slip$' -e '^zettelkasten$' -e '^thought$' -e '^knowledge$' -e '^distilled$' -e '^permanent$' | sort | uniq -c | sort -rn";
      };
    };

    # Bash shim: launch fish for interactive sessions
    programs.bash = {
      enable = true;
      historySize = 2500;
      historyControl = ["ignoredups" "erasedups"];

      initExtra = lib.mkOrder 2000 ''
        if [ -n "$PS1" ]; then
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        fi
      '';

      bashrcExtra = ''
        function gfp() {
          git fetch && git pull
        }

        function gsw() {
          local branch_flag=""
          case "''${1:-}" in
            a|all) branch_flag="-a" ;;
            r|remote) branch_flag="-r" ;;
            *) branch_flag="" ;;
          esac
          git branch $branch_flag --color=always | \
            grep -v HEAD | \
            sed 's/\(remotes\/\)\?origin\//> /' | \
            sed 's/^[[:space:]]*//' | \
            sort -u | \
            fzf --ansi --preview 'git log --oneline --graph --date=short --color=always -20 {}' | \
            xargs git switch
        }

        function gnb() {
          if [ -z "$1" ]; then
            echo "Usage: gnb <branch_name>"
            return 1
          fi
          git checkout -b "$1"
          git push -u origin "$1"
          echo "Successfully checked out to and pushed $1"
        }

        function docker-compose() {
          command docker compose
        }

        function :qa() { exit; }
        function :wq() { exit; }
        function :q() { exit; }

        function open() {
          xdg-open "$@"
        }
      '';
    };

    home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";
  };
}
