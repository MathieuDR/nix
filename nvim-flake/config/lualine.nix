{
  config.plugins.lualine = {
    enable = true;
    iconsEnabled = false;
    theme = "catppuccin";
    extensions = [ "fzf" ];
    componentSeparators = {
      left = "|";
      right = "|";
    };
    sectionSeparators = {
      left = "";
      right = "";
    };
    inactiveSections = {
      lualine_a = [{
        name = ''get_current_window'';
        extraConfig = {
          function = ''
            local get_current_window = function()
            	return vim.api.nvim_win_get_number(0)
            end
          '';
        };
      }];
      lualine_b = [ "" ];
      lualine_c = [ "filename" ];
      lualine_x = [ "location" ];
      lualine_y = [ "" ];
      lualine_z = [ "" ];
    };
  };
}
