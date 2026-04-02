{...}: {
  config.plugins.nvim-autopairs = {
    enable = true;
    settings = {
      check_ts = true;
      enable_check_bracket_line = true;
      # ignored_next_char = "[%w%.]";
      enable_afterquote = true;
      enable_moveright = true;
      disable_filetype = ["TelescopePrompt"];
    };

    luaConfig.post = ''
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')

      -- Rule for triple quotes (works for both ~H""" and regular """)
      npairs.add_rule(
        Rule('"""', '"""', {'heex', 'elixir'})
          :with_pair(function(opts)
            -- Only add closing quotes if we're at the end of the line
            local line = opts.line
            local col = opts.col
            if col > #line - 3 then
              -- Insert the closing quotes on a new line with proper indentation
              local indent = string.match(line, "^%s+") or ""
              vim.api.nvim_put({
                "",           -- Empty line between quotes
                indent .. '"""'  -- Closing quotes with same indentation
              }, "l", true, true)
              -- Move cursor to the empty line
              local crow, _ = unpack(vim.api.nvim_win_get_cursor(0))
              vim.api.nvim_win_set_cursor(0, {crow, #indent})
              return false -- Don't let autopairs handle it further
            end
            return false
          end)
      )
    '';
  };
}
