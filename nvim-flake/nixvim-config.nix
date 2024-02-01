{ lexicalPackage, ... }:
{
  config = {
    # THEME
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
    };

    # GLOBALS
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # HIGHLIGHT ON YANK
    autoGroups = {
      yanked_text = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = "TextYankPost";
        pattern = "*";
        # command = "vim.highlight.on_yank()";
        callback = {
          __raw = ''
            					function()
            						vim.highlight.on_yank()
            					end
            					'';
        };
        group = "yanked_text";
      }
    ];

    # BASE OPTIONS
    # TODO: CHECK IF `vim.o` and `vim.wo` is much different then vim.opts.
    # TODO: https://www.youtube.com/watch?v=Cp0iap9u29c
    options = {
      number = true;
      relativenumber = true;
      hlsearch = true;
      mouse = "a";
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      completeopt = "menuone,noselect";
      termguicolors = true;
      spelllang = "en_gb";
      spell = true;
      tabstop = 2;
      shiftwidth = 2;
    };

    plugins = {
      fugitive.enable = true;

      ## Auto complete
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
        mappingPresets = [ "insert" ];
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-CR>" = "cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})";
          "<Tab>" = {
            action = ''
              						function(fallback)
              							if cmp.visible() then
              								cmp.select_next_item()
              							elseif luasnip.expand_or_locally_jumpable() then
              								luasnip.expand_or_jump()
              							else
              								fallback()
              							end
              						end
              						'';
            modes = [
              "i"
              "s"
            ];
          };
          "<S-Tab>" = {
            action = ''
              						function(fallback)
              							if cmp.visible() then
              								cmp.select_prev_item()
              							elseif luasnip.locally_jumpable(-1) then
              								luasnip.jump(-1)
              							else
              								fallback()
              							end
              						end
              						'';
            modes = [
              "i"
              "s"
            ];
          };
        };
        autoEnableSources = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "cmdline"; }
        ];
      };

      luasnip = {
        enable = true;
        fromVscode = [{ }];
      };

      friendly-snippets.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          dockerls.enable = true;
          nixd.enable = true;
          tailwindcss.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;
          cssls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          #dartls.enable = true;
          elixirls = {
            enable = true;
            cmd = [ "${lexicalPackage}/bin/lexical" ];
          };
        };
      };
    };
  };
}
