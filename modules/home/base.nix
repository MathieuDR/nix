{...}: {
  flake.modules.homeManager.base = {inputs, ...}: {
    # Fundamentals always included with base
    imports = with inputs.self.modules.homeManager; [
      custom
      security
      fonts
      files
      packages
      scripts
    ];

    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
