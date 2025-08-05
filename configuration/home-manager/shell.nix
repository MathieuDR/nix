{
  self,
  pkgs,
  lib,
  config,
  ...
}: {
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
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
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
      # We're doing this solo to put it at the end
      enableBashIntegration = false;
    };

    bash = {
      enable = true;
      historySize = 2500;
      historyControl = ["ignoredups" "erasedups"];

      initExtra = lib.mkOrder 2000 ''
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

        function open(){
          xdg-open "$@"
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
