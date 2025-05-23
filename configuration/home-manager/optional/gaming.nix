{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      mangohud
      protonup
      (prismlauncher.override {jdks = [jdk8];})
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
