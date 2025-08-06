{
  pkgs,
  config,
  isDarwin,
  lib,
  ...
}:
lib.mkIf (!isDarwin) {
  systemd.user.tmpfiles.rules = [
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/io.element.desktop" = ["${pkgs.element-desktop.pname}.desktop"];
    };
  };
}
