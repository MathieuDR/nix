{
  config.plugins.lualine = {
    enable = true;
    iconsEnabled = false;
    theme = "catppuccin";
    componentSeparators = {
      left = "|";
      right = "|";
    };
    sectionSeparators = {
      left = "";
      right = "";
    };
    inactive_sections = {
      lualine_a = {
        __raw = "get_current_window";
        extraConfig = {
          __raw = ''
            local get_current_window = function()
            	return vim.api.nvim_win_get_number(0)
            end
          '';
        };
      };
      # lualine_a.__raw = "get_current_window";
      lualine_b = "";
      lualine_c = "filename";
      lualine_x = "location";
      lualine_y = "";
      lualine_z = "";
    };
  };
}
