{
  self,
  pkgs,
  lib,
  config,
  ...
}: {
  home = {
    shell = {
      enableFishIntegration = true;
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true; readonly and set to true?
      nix-direnv.enable = true;
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = builtins.fromJSON (builtins.readFile "${self}/data/.ysomic.omp.json");
    };

    jq.enable = true;
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

    lsd = {
      enable = true;
      enableBashIntegration = true;
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
      shellAliases = {
        "docker-compose" = "docker compose";
        ":qa" = "exit";
        ":wq" = "exit";
        ":q" = "exit";
      };

      interactiveShellInit = ''
        set fish_greeting
      '';

      functions = {
        gfp.body = ''
          git fetch
          and git pull
        '';

        # gnb = {
        #   argumentNames = "branch";
        #   body = ''
        #     if test -z "$branch"
        #       echo "Usage: gnb <branch_name>"
        #       return 1
        #     end
        #
        #     git checkout -b "$branch"
        #     or begin
        #       echo "Failed to checkout to branch $branch"
        #       return 1
        #     end
        #
        #     git push -u origin "$branch"
        #     or begin
        #       echo "Failed to push the branch $branch to origin"
        #       return 1
        #     end
        #
        #     echo "Successfully checked out to and pushed $branch"
        #   '';
        # };
      };
    };

    bash = {
      enable = false;
      historySize = 2500;
      historyControl = ["ignoredups" "erasedups"];

      # interactiveShellInit = ''
      #   if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      #   then
      #     shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      #     exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      #   fi
      # '';

      initExtra = lib.mkOrder 2000 ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
        eval "$(${pkgs.zoxide}/bin/zoxide init bash --cmd cd)"
      '';

      bashrcExtra = ''
        function gfp() {
        	git fetch && git pull
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
      '';
    };
  };

  home.sessionVariables = {
    ZEIT_DB = "${config.xdg.dataHome}/zeit.db";
  };
}
