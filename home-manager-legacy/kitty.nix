{...}: {
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    settings = {
      tab_bar_min_tabs = 1;
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      enable_audio_bell = false;
      scrollback_lines = 10000;
      disable_ligatures = "never";
    };
  };
}
