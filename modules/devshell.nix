{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.alejandra
        pkgs.git
        pkgs.just
        pkgs.fzf
        pkgs.nodePackages.prettier
        inputs.agenix.packages.${system}.default
      ];
      name = "dots";
      DIRENV_LOG_FORMAT = "";
      shellHook = ''
        ${config.pre-commit.installationScript}
      '';
    };

    formatter = pkgs.alejandra;

    pre-commit = {
      settings.excludes = ["flake.lock"];
      settings.hooks = {
        alejandra.enable = true;
        prettier = {
          enable = true;
          excludes = [".js" ".md" ".ts"];
        };
      };
    };
  };
}
