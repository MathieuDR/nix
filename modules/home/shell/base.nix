{inputs, ...}: {
  flake.modules.homeManager.shell = {
    pkgs,
    config,
    ...
  }: {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = config.programs.bash.enable;
        nix-direnv.enable = true;
      };

      oh-my-posh = {
        enable = true;
        enableBashIntegration = config.programs.bash.enable;
        enableFishIntegration = config.programs.fish.enable;
        settings = builtins.fromJSON (builtins.readFile "${inputs.self}/data/.ysomic.omp.json");
      };

      jq.enable = true;
      fd.enable = true;
      bat.enable = true;
      bottom.enable = true;
      rclone.enable = true;

      eza = {
        enable = true;
        enableBashIntegration = false; # intentional
        enableFishIntegration = config.programs.fish.enable;
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

      zoxide = {
        enable = true;
        options = ["--cmd cd"];
        enableBashIntegration = false; # intentional, error
        enableFishIntegration = config.programs.fish.enable;
      };
    };

    home.sessionVariables = {
      ZEIT_DB = "${config.xdg.dataHome}/zeit.db";
    };
  };
}
