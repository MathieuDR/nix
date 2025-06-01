{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    package = (
      pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          uosc
          mpris
        ];

        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;

          # Use ffmpeg-full for comprehensive codec support
          ffmpeg = pkgs.ffmpeg-full;
          #vaapiSupport = true;

          # Enable hardware acceleration options
          # vulkanSupport = true;
          pipewireSupport = true;
        };
      }
    );

    config = {
      # High quality video profile
      profile = "gpu-hq";

      # mpv ~/Kooha/Kooha-2025-05-26-23-19-26.webm  --vo=gpu-next --gpu-api=opengl --hwdec=auto
      # Hardware acceleration (adjust based on your GPU)
      # hwdec = "vulkan";
      vo = "gpu-next";
      gpu-api = "opengl";
      hwdec = "auto";

      # gpu-api = "vulkan";
      # GPU API preference for NVIDIA
      # gpu-api = "vulkan"; # vulkan generally performs better on NVIDIA than opengl
      # NVIDIA-specific optimizations
      # vd-lavc-dr = "yes"; # Enable direct rendering

      # Audio settings
      audio-file-auto = "fuzzy";

      # Subtitle settings
      sub-auto = "fuzzy";

      # Cache settings for smooth playback
      cache = true;
      demuxer-max-bytes = "150MiB";
      demuxer-max-back-bytes = "50MiB";

      # Window behavior
      keep-open = true; # Don't close when playback ends

      # OSD settings
      osd-level = 1;
      osd-duration = 2500;
    };

    # Key bindings for better control
    bindings = {
      "WHEEL_UP" = "seek 10";
      "WHEEL_DOWN" = "seek -10";
      "Alt+ENTER" = "cycle fullscreen";
      "Ctrl+=" = "add audio-delay 0.100";
      "Ctrl+-" = "add audio-delay -0.100";
      "i" = "script-binding stats/display-stats-toggle"; # Show performance stats
    };
  };
}
