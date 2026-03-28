{...}: {
  flake.modules.homeManager.mpv = {pkgs, ...}: {
    programs.mpv = {
      enable = true;
      package = pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          uosc
          mpris
        ];
        mpv-unwrapped = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
          ffmpeg = pkgs.ffmpeg-full;
          pipewireSupport = true;
        };
      };

      config = {
        profile = "gpu-hq";
        vo = "gpu-next";
        gpu-api = "opengl";
        hwdec = "auto";
        audio-file-auto = "fuzzy";
        sub-auto = "fuzzy";
        cache = true;
        demuxer-max-bytes = "150MiB";
        demuxer-max-back-bytes = "50MiB";
        keep-open = true;
        osd-level = 1;
        osd-duration = 2500;
      };

      bindings = {
        "WHEEL_UP" = "seek 10";
        "WHEEL_DOWN" = "seek -10";
        "Alt+ENTER" = "cycle fullscreen";
        "Ctrl+=" = "add audio-delay 0.100";
        "Ctrl+-" = "add audio-delay -0.100";
        "i" = "script-binding stats/display-stats-toggle";
      };
    };
  };
}
