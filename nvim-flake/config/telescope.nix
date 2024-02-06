{
  config.plugins = {
    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };
  };

  config.keymaps = [
    # LSP
    # Might want to put this on attach with buffer
    {
      mode = "n";
      key = "gr";
      action.__raw = "require('telescope.builtin').lsp_references";
      options = {
        desc = "LSP: [G]oto [R]eferences";
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action.__raw = "require('telescope.builtin').lsp_document_symbols";
      options = {
        desc = "LSP: [D]ocument [S]ymbols";
      };
    }
    {
      mode = "n";
      key = "<leader>ws";
      action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
      options = {
        desc = "LSP: [W]orkspace [S]ymbols";
      };
    }

    # COMMON 
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
      key = "<leader>gf";
      action.__raw = "require('telescope.builtin').git_files";
      options = {
        desc = "Search [G]it [F]iles";
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
      key = "<leader>sh";
      action.__raw = "require('telescope.builtin').help_tags";
      options = {
        desc = "[S]earch [H]elp";
      };
    }
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
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = "require('telescope.builtin').diagnostics";
      options = {
        desc = "[S]earch [D]iagnostics";
      };
    }
  ];
}
