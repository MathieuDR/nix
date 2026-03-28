{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # Host tool choices — change these to swap terminal/browser/etc.
  custom = {
    terminal = {
      package = pkgs.kitty;
      command = lib.getExe pkgs.kitty;
      execArgs = "--hold -e";
    };
    browser = {
      package = config.programs.zen-browser.finalPackage;
      command = "${config.programs.zen-browser.finalPackage}/bin/zen";
    };
    fileManager = {
      package = pkgs.xfce.thunar;
      command = lib.getExe pkgs.xfce.thunar;
    };
    launcher = {
      package = pkgs.rofi;
      command = lib.getExe pkgs.rofi;
      drunCommand = "${lib.getExe pkgs.rofi} -show drun";
      windowCommand = "${lib.getExe pkgs.rofi} -show window";
    };
  };

  home = {
    username = "thieu";
    homeDirectory = "/home/thieu";
    stateVersion = "25.11";

    packages = [
      pkgs.calibre
      inputs.self.packages.${pkgs.system}.castersoundboard
      inputs.self.packages.${pkgs.system}.dungeondraft
    ];
  };

  # Health check monitoring (disabled — server is broken)
  maintenance.healthchecks = {
    enable = false;
    addresses = [
      "firesprout.home.deraedt.dev"
      "hpi.home.deraedt.dev"
      "mathieu.deraedt.dev"
      "drakkenheim.deraedt.dev"
    ];
    notifications.enable = true;
  };
}
