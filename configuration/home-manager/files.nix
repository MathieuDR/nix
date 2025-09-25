{
  pkgs,
  config,
  isDarwin,
  lib,
  ...
}: {
  systemd.user.tmpfiles.rules = lib.mkIf (!isDarwin) [
    # d /path/to/directory MODE USER GROUP AGE ARGUMENT
    "d ${config.home.homeDirectory}/downloads 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development/sources 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development/courses 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development/sources/sevenmind 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/pictures 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/pictures/screenshots 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/notes 0755 ${config.home.username} users - -"
  ];

  home.activation = lib.mkIf isDarwin {
    createDevelopmentDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/downloads"
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/development"
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/development/sources"
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/development/courses"
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/development/sources/sevenmind"
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/pictures"
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/pictures/screenshots"
      $DRY_RUN_CMD mkdir -p -m 755 "${config.home.homeDirectory}/notes"
    '';
  };

  # Linux only: XDG mime applications (not applicable to macOS)
  xdg.mimeApps = lib.mkIf (!isDarwin) {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/io.element.desktop" = ["${pkgs.element-desktop.pname}.desktop"];
    };
  };
}
