{
  pkgs,
  config,
  isDarwin,
  lib,
  ...
}: let
  customDirs = {
    development = "${config.home.homeDirectory}/development";
    developmentSources = "${config.home.homeDirectory}/development/sources";
    developmentCourses = "${config.home.homeDirectory}/development/courses";
    screenshots = "${config.home.homeDirectory}/pictures/screenshots";
    notes = "${config.home.homeDirectory}/notes";
    drakkenheim = "${config.home.homeDirectory}/notes/drakkenheim";
    obsidian = "${config.home.homeDirectory}/notes/obsidian";
  };

  customDirsList = lib.attrValues customDirs;

  repos = [
    {
      url = "https://github.com/MathieuDR/nix";
      dir = "development/sources/nixos";
    }
    {
      url = "https://github.com/MathieuDR/nixvim";
      dir = "development/sources/nixvim";
    }
    {
      url = "https://github.com/MathieuDR/nix-dock";
      dir = "development/sources/nix-dock";
    }
    {
      url = "https://github.com/MathieuDR/homeserver";
      dir = "development/sources/homeserver";
    }
    {
      url = "https://github.com/MathieuDR/Obsidian";
      dir = "notes/obsidian";
    }
    {
      url = "https://github.com/MathieuDR/drakkenheim-notes";
      dir = "notes/drakkenheim";
    }
  ];

  cloneRepos = repo: ''
    if [ ! -d "${config.home.homeDirectory}/${repo.dir}" ]; then
      $VERBOSE_ECHO "Cloning ${repo.url} to ${repo.dir}"
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone ${repo.url} "${config.home.homeDirectory}/${repo.dir}"
    fi
  '';
in {
  xdg = lib.mkIf (!isDarwin) {
    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
      templates = "${config.home.homeDirectory}/templates";
      publicShare = "${config.home.homeDirectory}/public";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/io.element.desktop" = ["${pkgs.element-desktop.pname}.desktop"];
      };
    };
  };

  systemd.user.tmpfiles.rules = lib.mkIf (!isDarwin) (
    map (dir: "d ${dir} 0755 ${config.home.username} users - -") customDirsList
  );

  home.activation = lib.mkMerge [
    (lib.mkIf isDarwin {
      createCustomDirs = lib.hm.dag.entryAfter ["writeBoundary"] (
        lib.concatStringsSep "\n" (
          map (dir: "$DRY_RUN_CMD mkdir -p -m 755 \"${dir}\"") customDirsList
        )
      );
    })
    {
      cloneRepos = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${lib.concatMapStringsSep "\n" cloneRepos repos}
      '';
    }
  ];
}
