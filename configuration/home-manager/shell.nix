{
  self,
  pkgs,
  lib,
  config,
  isDarwin,
  ...
}: {
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      # Readonly, set multiple times?
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = builtins.fromJSON (builtins.readFile "${self}/data/.ysomic.omp.json");
    };

    jq.enable = true;
    fd.enable = true;
    #TODO: Can give bat actual theme. Lets look at that
    bat.enable = true;
    bottom.enable = true;
    #TODO: Can do more, can set remotes!
    rclone.enable = true;
    eza = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = true;
      #NOTE: I think this can be disabled (the theme) as nix catpuccin does this.
      #NOTE: needs to be 'yaml'
      #https://github.com/eza-community/eza-themes/blob/main/themes/catppuccin.yml
      #yq -j . eza.theme.yml | eza.theme.json
      # theme = lib.mkForce (builtins.fromJSON (builtins.readFile "${self}/data/config/eza.theme.json"));
    };
    ripgrep.enable = true;
    gh.enable = true;
    fzf.enable = true;

    git = {
      enable = true;
      settings = {
        user = {
          name = "MathieuDR";
          email = "mathieu@deraedt.dev";
        };

        #NOTE: Does this work?
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };

      signing = {
        key = "BB1B6AEC733F6F80";
        signByDefault = true;
      };
    };

    difftastic = {
      enable = true;
      git.enable = true;
      options = {
        display = "side-by-side";
        background = "dark";
      };
    };

    #NOTE: Trying Eza for a bit.
    lsd = {
      enable = false;
      enableBashIntegration = false;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
      # We're doing this solo to put it at the end
      enableBashIntegration = false;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      interactiveShellInit = lib.mkMerge [
        ''
          set fish_greeting # Disable greeting
        ''

        (lib.mkIf isDarwin ''
          # Add Homebrew to PATH on macOS
          eval "$(/opt/homebrew/bin/brew shellenv)"
        '')
      ];

      functions =
        {
          fish_title = {
            description = "Set terminal title with smart path formatting";
            body = ''
              # $argv[1] contains the entire command line as a string
              set -l cmd_line $argv[1]

              # Get current directory
              set -l current_dir (pwd)

              # Split path into components first
              set -l path_parts (string split "/" $current_dir)
              set -l num_parts (count $path_parts)

              # Determine how many parent directories to show
              set -l formatted_path

              # Check if we're exactly at home directory
              if test "$current_dir" = "$HOME"
                set formatted_path "~"
              # Check if we're one level deep in home (~/foo)
              else if string match -q "$HOME/*" $current_dir
                set -l rel_path (string replace "$HOME/" "" $current_dir)
                set -l rel_parts (string split "/" $rel_path)
                set -l rel_count (count $rel_parts)

                if test $rel_count -le 2
                  # ~/foo or ~/foo/bar - show as is
                  set formatted_path "~/"(string join "/" $rel_parts)
                else
                  # ~/foo/bar/baz or deeper - show as ~/../bar/baz (last 2 components)
                  set formatted_path "~/../"(string join "/" $rel_parts[-2..-1])
                end
              else
                # Not in home, show last 3 components from root
                if test $num_parts -le 3
                  set formatted_path (string join "/" $path_parts)
                else
                  set formatted_path "../"(string join "/" $path_parts[-2..-1])
                end
              end

              # Build the title based on command line
              if test -n "$cmd_line"
                # Split command line into parts
                set -l cmd_parts (string split " " $cmd_line)

                if test (count $cmd_parts) -gt 1
                  # Command with arguments - show command and first arg
                  echo "$cmd_parts[1] $cmd_parts[2]"
                else
                  # Command without arguments - show command with path
                  echo "$cmd_parts[1] $formatted_path"
                end
              else
                # No command (at prompt) - just show path
                echo "$formatted_path"
              end
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
            #NOTE:
            # We do not set branch_flag as "", otherwise fish will expand it. If we don't set it, it won't be expanded.
            # Strange...
            body = ''
              # Parse the scope argument (all/a, remote/r
              switch $argv[1]
                  case a all
                      set branch_flag "-a"
                  case r remote
                      set branch_flag "-r"
              end

              # List branches, format them, and use fzf to select
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
        }
        // (lib.optionalAttrs (!isDarwin) {
          open = {
            description = "Open files with default application";
            body = ''
              xdg-open $argv
            '';
          };
        });

      # Fish abbreviations
      shellAbbrs = {
        # Vim-style exits
        ":qa" = "exit";
        ":wq" = "exit";
        ":q" = "exit";

        # Git shortcuts that expand to full commands
        g = "git";
        gs = "git status";
        gswm = "git switch main";
        gswt = "git switch -";
        gd = "git diff";
        ga = "git add";
        gap = "git add -p";
        gc = "git commit";
        gca = "git commit --amend";
        gco = "git checkout";
        gl = "git log --oneline --graph --decorate";
        gp = "git push";
        gpfo = "git push --force-with-lease";
        # gpu = "git push -u origin HEAD";
        gpr = "gh pr new";
        gvpr = "gh pr view --web";
        grc = "git rebase --continue";
      };
    };

    bash = {
      enable = true;
      historySize = 2500;
      historyControl = ["ignoredups" "erasedups"];

      # Use interactiveShellInit for fish exec - only runs in interactive shells
      # https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell
      # https://github.com/NixOS/nixpkgs/blob/7e297ddff44a3cc93673bb38d0374df8d0ad73e4/nixos/modules/programs/bash/bash.nix#L204
      initExtra = lib.mkOrder 2000 ''
        # We don't need zoxide anymore in bash.
        # eval "$(${pkgs.zoxide}/bin/zoxide init bash --cmd cd)"

        if [ -n "$PS1" ]; then
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        fi
      '';

      bashrcExtra = lib.mkMerge [
        ''
          function gfp() {
          	git fetch && git pull
          }

          function gsw() {
            local branch_flag=""

            case "$\{1:-\}" in
              a|all)
                branch_flag="-a"
                ;;
              r|remote)
                branch_flag="-r"
                ;;
              *)
                branch_flag=""
                ;;
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

          	if [ $? -ne 0 ]; then
          	  echo "Failed to checkout to branch $1"
          	  return 1
          	fi

          	git push -u origin "$1"

          	if [ $? -ne 0 ]; then
          	  echo "Failed to push the branch $1 to origin"
          	  return 1
          	fi

          	echo "Successfully checked out to and pushed $1"
          }


          function docker-compose() {
            command docker compose
          }

          function :qa() {
            exit
          }

          function :wq() {
            exit
          }

          function :q() {
            exit
          }
        ''

        (lib.mkIf (! isDarwin) ''
          function open(){
            xdg-open "$@"
          }
        '')

        (lib.mkIf isDarwin ''
          eval "$(/opt/homebrew/bin/brew shellenv)"
          export EDITOR=nvim
        '')
      ];
    };
  };

  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
    ZEIT_DB = "${config.xdg.dataHome}/zeit.db";
  };
}
