{
  config.plugins = {
    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };
  };

  config.keymaps = [
    # LSP
    {
      mode = "n";
      key = "<leader>lr";
      action.__raw = "require('telescope.builtin').lsp_references";
      options = {
        desc = "LSP: [G]oto [R]eferences";
      };
    }
    {
      mode = "n";
      key = "<leader>ls";
      action.__raw = "require('telescope.builtin').lsp_document_symbols";
      options = {
        desc = "LSP: [D]ocument [S]ymbols";
      };
    }
    {
      mode = "n";
      key = "<leader>lws";
      action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
      options = {
        desc = "LSP: [W]orkspace [S]ymbols";
      };
    }

    # BUFFERS / FILES
    {
      mode = "n";
      key = "<leader>m";
      action.__raw = "require('telescope.builtin').marks";
      options = {
        desc = "Find [M]arks";
      };
    }
    {
      mode = "n";
      key = "<leader>?";
      action.__raw = "require('telescope.builtin').oldfiles";
      options = {
        desc = "[?] Find recently opened files";
      };
    }
    {
      mode = "n";
      key = "<leader><space>";
      action.__raw = "require('telescope.builtin').buffers";
      options = {
        desc = "[ ] Find existing buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>/";
      action.__raw = ''
        function()
        	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        		winblend = 10,
        		previewer = false,
        	})
        end
      '';
      options = {
        desc = "[/] Fuzzily search in current buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>sf";
      action.__raw = "require('telescope.builtin').find_files";
      options = {
        desc = "[S]earch [F]iles";
      };
    }
    {
      mode = "n";
      key = "<leader>sa";
      action.__raw = "function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true;}) end";
      options = {
        desc = "[S]earch [A]ll Files (ignored & hidden)";
      };
    }
    {
      mode = "n";
      key = "<leader>sh";
      action.__raw = "function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true;}) end";
      options = {
        desc = "[S]earch [H]idden Files";
      };
    }

    # GREP
    {
      mode = "n";
      key = "<leader>sw";
      action.__raw = "require('telescope.builtin').grep_string";
      options = {
        desc = "[S]earch current [W]ord";
      };
    }
    {
      mode = "n";
      key = "<leader>sg";
      action.__raw = "require('telescope.builtin').live_grep";
      options = {
        desc = "[S]earch by [G]rep";
      };
    }

    # OTHERS
    {
      mode = "n";
      key = "<leader>hh";
      action.__raw = "require('telescope.builtin').help_tags";
      options = {
        desc = "Search [H]elp";
      };
    }
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = "require('telescope.builtin').diagnostics";
      options = {
        desc = "[S]earch [D]iagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>sp";
      action.__raw = "function() require('telescope.builtin').find_files({ cwd = vim.fn.input('Path: ', '', 'dir') }) end";
      options = {
        desc = "[S]earch in [P]ath";
      };
    }
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = ''
        function()
          require('telescope.builtin').find_files({
            cwd = "dev/",
            hidden = true,
            no_ignore = true,
          })
        end
      '';
      options = {
        desc = "[S]earch [D]ev folder";
      };
    }

    # GIT
    {
      mode = "n";
      key = "<leader>gs";
      action.__raw = "require('telescope.builtin').git_status";
      options = {
        desc = "[G]it [S]tatus";
      };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action.__raw = "require('telescope.builtin').git_branches";
      options = {
        desc = "[G]it [B]ranches";
      };
    }
    {
      mode = "n";
      key = "<leader>gt";
      action.__raw = "require('telescope.builtin').git_stash";
      options = {
        desc = "[G]it S[t]ashes";
      };
    }
    {
      mode = "n";
      key = "<leader>gf";
      action.__raw = "require('telescope.builtin').git_files";
      options = {
        desc = "Search [G]it [F]iles";
      };
    }
  ];
}
