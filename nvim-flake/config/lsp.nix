{ lexicalPackage, ... }:
{
  config = {
    plugins = {
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
          dartls.enable = true;
          elixirls = {
            enable = true;
            cmd = [ "${lexicalPackage}/bin/lexical" ];
          };
        };
      };


    };
  };
}
