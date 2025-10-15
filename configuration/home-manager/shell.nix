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
      #TODO: needs to be 'yaml'
      #https://github.com/eza-community/eza-themes/blob/main/themes/catppuccin.yml
      #yq -j . eza.theme.yml | eza.theme.json
      theme = builtins.fromJSON (builtins.readFile "${self}/data/config/eza.theme.json");
    };
    ripgrep.enable = true;
    gh.enable = true;
    fzf.enable = true;

    git = {
      enable = true;
      userName = "MathieuDR";
      userEmail = "mathieu@deraedt.dev";
      signing = {
        key = "BB1B6AEC733F6F80";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };

      difftastic = {
        enable = true;
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
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';

      functions =
        {
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
      initExtra = lib.mkOrder 2000 (
        if isDarwin
        then ''
          if [ -n "$PS1" ]; then
            if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          fi
        ''
        else ''
          # We don't need zoxide anymore in bash.
          # eval "$(${pkgs.zoxide}/bin/zoxide init bash --cmd cd)"

          if [ -n "$PS1" ]; then
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          fi
        ''
      );

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
    # SHELL = "${pkgs.bash}/bin/bash";
    ZEIT_DB = "${config.xdg.dataHome}/zeit.db";
  };
}
