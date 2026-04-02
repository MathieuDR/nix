{...}: {
  config.keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>st";
      action.__raw = ''
        function()
          -- Function to set up the autocommand for the new buffer
          local function setup_mkdir_autocmd()
            local bufnr = vim.api.nvim_get_current_buf()
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,  -- Make it buffer-local
              once = true,     -- Only trigger once
              callback = function()
                local dir = vim.fn.expand("<afile>:p:h")
                if vim.fn.isdirectory(dir) == 0 then
                  vim.fn.mkdir(dir, "p")
                  vim.notify("Created directory: " .. dir, vim.log.levels.INFO)
                end
              end,
              desc = "Create directory structure on first save"
            })
          end

          local current_file = vim.fn.expand('%:p')
          local filetype = vim.bo.filetype

          -- Try to load project-specific patterns first
          local project_config = nil
          local config_paths = {
            vim.fn.getcwd() .. '/.nvim/test_patterns.lua',
            vim.fn.expand('~/.config/nvim/project_patterns/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. '.lua')
          }

          for _, path in ipairs(config_paths) do
            local f = io.open(path, "r")
            if f then
              f:close()
              project_config = dofile(path)
              break
            end
          end

          -- Default patterns
          local default_patterns = {
            elixir = {
              src_pattern = "^(.+)/lib/(.+)%.ex$",
              test_pattern = "^(.+)/test/(.+)_test%.exs$",
              src_template = "%s/lib/%s.ex",
              test_template = "%s/test/%s_test.exs"
            },
            -- Add more language patterns here
          }

          -- Merge project config with defaults
          local patterns = vim.tbl_deep_extend("force",
            default_patterns,
            project_config or {}
          )

          -- Check if filetype is supported
          local lang_pattern = patterns[filetype]
          if not lang_pattern then
            vim.notify("Unsupported filetype: " .. filetype, vim.log.levels.WARN)
            return
          end

          -- Try to match source file pattern
          local root, path = current_file:match(lang_pattern.src_pattern)
          if root and path then
            -- We're in a source file, switch to test
            local test_file = string.format(lang_pattern.test_template, root, path)
            vim.cmd('edit ' .. test_file)
            setup_mkdir_autocmd()
            return
          end

          -- Try to match test file pattern
          root, path = current_file:match(lang_pattern.test_pattern)
          if root and path then
            -- We're in a test file, switch to source
            local src_file = string.format(lang_pattern.src_template, root, path)
            vim.cmd('edit ' .. src_file)
            return
          end

          -- If we get here, the file doesn't match our patterns
          vim.notify("File doesn't match expected source or test patterns for " .. filetype, vim.log.levels.WARN)
        end
      '';
      options = {
        desc = "[S]witch between [T]est/Source files";
        silent = true;
        noremap = true;
      };
    }
  ];
}
