{ lexicalPackage, ... }:
{
  config = {
    plugins = {
      ## Treesitter
      treesitter = {
        enable = true;
        ensureInstalled = [ "bash" "bibtex" "c_sharp" "cmake" "css" "csv" "dart" "diff" "dockerfile" "dot" "eex" "elixir" "erlang" "fish" "fsh" "gitignore" "heex" "http" "hurl" "html" "ini" "javascript" "jg" "json" "latex" "lua" "nix" "regex" "ruby" "scss" "sql" "terraform" "typescript" "vimdoc" "vim" "xml" "yaml" "markdown" "markdown_inline" ];
        indent = true;
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "<c-space>";
            nodeDecremental = "<M-space>";
            nodeIncremental = "<c-space>";
            scopeIncremental = "<c-s>";
          };
        };
      };

      treesitter-textobjects = {
        enable = true;
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
          };
        };
        move = {
          enable = true;
          setJumps = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swapNext = {
            "<leader>a" = "@parameter.inner";
          };
          swapPrevious = {
            "<leader>A" = "@parameter.inner";
          };
        };
      };


      treesitter-context.enable = true;

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
          { name = "path"; }
          { name = "cmdline"; }
        ];
      };

      luasnip = {
        enable = true;
        fromVscode = [{ }];
      };

      friendly-snippets.enable = true;

      ### LSP
      fidget.enable = true;

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
          dartls.enable = true;
          elixirls = {
            enable = true;
            cmd = [ "${lexicalPackage}/bin/lexical" ];
          };
        };
        keymaps = {
          diagnostic = {
            "[d" = {
              action = "goto_prev";
              desc = "Go to previous diagnostic message";
            };
            "]d" = {
              action = "goto_next";
              desc = "Go to next diagnostic message";
            };
            "<leader>e" = {
              action = "open_float";
              desc = "Open floating diagnostic message";
            };
            "<leader>q" = {
              action = "setloclist";
              desc = "Open diagnostic list";
            };
          };

          lspBuf = {
            "<leader>rn" = {
              action = "rename";
              desc = "[R]e[n]ame";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "[C]ode [A]ction";
            };
            "gd" = {
              action = "definition";
              desc = "[G]oto [D]efinition";
            };
            "gI" = {
              action = "implementation";
              desc = "[G]oto [I]mplementation";
            };
            "<leader>D" = {
              action = "type_definition";
              desc = "Type [D]efinition";
            };
            "K" = {
              action = "hover";
              desc = "Hover documentation";
            };
            "<c-k>" = {
              action = "signature_help";
              desc = "Signature Documentation";
            };
            "gD" = {
              action = "declaration";
              desc = "[G]oto [D]eclaration";
            };
            "<leader>wa" = {
              action = "add_workspace_folder";
              desc = "[W]orkspace [A]dd Folder";
            };
            "<leader>wr" = {
              action = "remove_workspace_folder";
              desc = "[W]orkspace [R]emove Folder";
            };
            "<leader>wl" = {
              action = "list_workspace_folders";
              desc = "[W]orkspace [L]ist Folders";
            };
            "<leader>f" = {
              action = "format";
              desc = "Format current buffer with LSP";
            };
          };
        };
      };
    };
  };
}
