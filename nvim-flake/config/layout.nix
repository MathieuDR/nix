{
  config = {
    plugins = {
      lualine = {
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
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            { name = "branch"; icon = ""; }
            "diff"
            "diagnostics"
          ];
          lualine_c = [ "filename" ];
          lualine_x = [ "filetype" ];
          lualine_y = [ "progress" ];
          lualine_z = [ ''" " .. os.date("%R")'' ];
        };
        inactiveSections = {
          lualine_a = [ ''" " .. vim.api.nvim_win_get_number(0)'' ];
          lualine_b = [ "" ];
          lualine_c = [ "filename" ];
          lualine_x = [ "" ];
          lualine_y = [ "" ];
          lualine_z = [ "" ];
        };
      };
      indent-blankline = {
        enable = true;
        indent.char = "┆";
      };
    };
  };
}
