{...}: {
  flake.modules.homeManager.kitty = {pkgs, ...}: {
    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10;
      };
      settings = {
        window_title = "{title} - Kitty";
        tab_bar_min_tabs = 1;
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        enable_audio_bell = false;
        scrollback_lines = 1000;
        disable_ligatures = "never";
        symbol_map = "U+1F300-U+1F9FF Noto Color Emoji";
        font_features = "none";

        confirm_os_window_close = 0;
        window_padding_width = 8;
      };
    };
  };
}
