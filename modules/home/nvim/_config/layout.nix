{
  config = {
    plugins = {
      lualine = {
        enable = true;
        settings = {
          extensions = ["fzf"];
          inactive_sections = {
            lualine_a = [''" " .. vim.api.nvim_win_get_number(0)''];
            lualine_b = [""];
            lualine_c = ["filename"];
            lualine_x = [""];
            lualine_y = [""];
            lualine_z = [""];
          };
          sections = {
            lualine_a = ["mode"];
            lualine_b = [
              "branch"
              "diff"
              "diagnostics"
            ];
            lualine_c = ["filename"];
            lualine_x = ["filetype"];
            lualine_y = ["progress"];
            lualine_z = [''" " .. os.date("%R")''];
          };

          options = {
            iconsEnabled = false;
            theme = "catppuccin";
            component_separators = {
              left = "|";
              right = "|";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
        };
      };

      indent-blankline = {
        enable = true;
        settings.indent.char = "┆";
      };
    };
  };
}
