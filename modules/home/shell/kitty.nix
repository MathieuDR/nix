{...}: {
  flake.modules.homeManager.kitty = {pkgs, ...}: {
    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
      settings = {
        confirm_os_window_close = 0;
        scrollback_lines = 10000;
        enable_audio_bell = false;
        window_padding_width = 8;
      };
    };
  };
}
