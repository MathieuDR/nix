{ pkgs, ... }: {
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-easy-align
      executor-nvim
      vim-markdown # Not nvim-markdown but suffices for now
      nvim-surround
      telescope-symbols-nvim
    ];

    extraConfigLuaPost = ''
            			require("vim-easy-align").setup({})
            			require("executor").setup({})
            			require("vim-markdown").setup({})
            			require("nvim-surround").setup({})

      						vim.g.vim_markdown_conceal = 0
            		'';

    keymaps = [
      {
        mode = "x";
        key = "ga";
        action = "<Plug>(EasyAlign)";
        options = {
          desc = "Start interactive EasyAlign in visual mode";
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "ga";
        action = "<Plug>(EasyAlign)";
        options = {
          desc = "Start interactive EasyAlign for motion/text object";
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<Leader>si";
        action = ":lua require'telescope.builtin'.symbols{ sources = {'gitmoji'} }<CR>";
        options = {
          desc = "[S]earch [I]con";
          noremap = true;
        };
      }
    ];
  };
}
