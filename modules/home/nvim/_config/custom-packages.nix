{pkgs, ...}: {
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-easy-align
      executor-nvim
      nvim-surround
      telescope-symbols-nvim
    ];

    extraConfigLuaPost = ''
      require("executor").setup({})
      require("nvim-surround").setup({})
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

      # Executor
      {
        mode = "n";
        key = "<leader>rr";
        action = ":ExecutorRun<CR>";
        options = {
          desc = "[R]un executor";
        };
      }
      {
        mode = "n";
        key = "<leader>rd";
        action = ":ExecutorToggleDetail<CR>";
        options = {
          desc = "[R]un [D]etails";
        };
      }
      {
        mode = "n";
        key = "<leader>rs";
        action = ":ExecutorSetCommand<CR>";
        options = {
          desc = "[R]un [S]et command";
        };
      }
    ];
  };
}
