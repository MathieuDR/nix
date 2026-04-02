{
  lexicalPackage,
  pkgs,
  ...
}: let
  snippetsDir = pkgs.stdenv.mkDerivation {
    name = "nvim-snippets";
    src = ../../../../data/snippets;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in {
  config = {
    plugins = {
      ## Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          ensureInstalled = [
            "python"
            "go"
            "bash"
            "c_sharp"
            "cmake"
            "css"
            "csv"
            "dart"
            "diff"
            "dockerfile"
            "eex"
            "elixir"
            "erlang"
            "gitattributes"
            "gitignore"
            "git_config"
            "git_rebase"
            "heex"
            "http"
            "hurl"
            "html"
            "ini"
            "javascript"
            "typescript"
            "jq"
            "json"
            "lua"
            "nix"
            "regex"
            "ruby"
            "scss"
            "terraform"
            "xml"
            "yaml"
            "markdown"
            "markdown_inline"
            "svelte"
            "zig"
          ];
          indent.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<c-space>";
              node_decremental = "<M-space>";
              node_incremental = "<c-space>";
              scope_incremental = "<c-s>";
            };
          };
        };
      };

      treesitter-textobjects = {
        enable = true;
        settings = {
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
            set_jumps = true;
            goto_next_start = {
              "]m" = "@function.outer";
              "]]" = "@class.outer";
            };
            goto_next_end = {
              "]M" = "@function.outer";
              "][" = "@class.outer";
            };
            goto_previous_start = {
              "[m" = "@function.outer";
              "[[" = "@class.outer";
            };
            goto_previous_end = {
              "[M" = "@function.outer";
              "[]" = "@class.outer";
            };
          };
          swap = {
            enable = true;
            swap_next = {
              "<leader>a" = "@parameter.inner";
            };
            swap_previous = {
              "<leader>A" = "@parameter.inner";
            };
          };
        };
      };

      treesitter-context.enable = true;

      ## Auto complete
      cmp = {
        enable = true;
        settings = {
          snippet.expand = ''
            function(args)
            	require('luasnip').lsp_expand(args.body)
            end
          '';
          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                elseif require('luasnip').locally_jumpable(1) then
                  require('luasnip').jump(1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<Tab>" = ''
              cmp.mapping(function(fallback)
              	if cmp.visible() then
              		cmp.select_next_item()
              	elseif require('luasnip').expand_or_locally_jumpable() then
              		require('luasnip').expand_or_jump()
              	else
              		fallback()
              	end
              end, {'i','s'})
            '';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                      	if cmp.visible() then
                      		cmp.select_prev_item()
                      	elseif require('luasnip').locally_jumpable(-1) then
                      		require('luasnip').jump(-1)
                      	else
                      		fallback()
                      	end
                      end, {"i", "s"})
            '';
          };
          autoEnableSources = true;
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            # {
            #   name = "buffer";
            #   option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            # }
            # {name = "path";}
            # {name = "cmdline";}
          ];
        };
      };

      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;

      luasnip = {
        enable = true;
        fromVscode = [
          {}
          {paths = "${snippetsDir}";}
        ];
      };

      friendly-snippets.enable = true;

      ### LSP
      fidget.enable = true;
      lsp-format.enable = true;

      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources.formatting.alejandra.enable = true;
      };

      lsp = {
        enable = true;
        capabilities = ''
          capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          }
        '';
        servers = {
          bashls.enable = true;
          dockerls.enable = true;
          nixd.enable = true;
          ts_ls.enable = true;
          svelte.enable = true;
          tailwindcss.enable = true;
          terraformls.enable = true;
          yamlls.enable = true;
          cssls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          dartls.enable = true;
          gopls.enable = true;
          typst_lsp.enable = false;
          zls.enable = false; # zls-0.15.1 fails to build in the Nix sandbox (Zig 0.14 /p cache issue); re-enable when nixpkgs fixes it
          pyright.enable = true;
          lexical = {
            enable = true;
            package = lexicalPackage;
          };
        };
        onAttach = ''
          -- Create a command `:Format` local to the LSP buffer
          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          	vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })
        '';
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

    extraConfigLuaPost = ''
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local f = ls.function_node

      ls.add_snippets("markdown", {
        s("bl", {
          t("^"),
          f(function()
            math.randomseed(os.time())
            return string.format("%06x", math.random(0, 0xFFFFFF))
          end, {}),
        }),
      })
    '';
  };
}
