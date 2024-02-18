{ pkgs, ... }: {
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-easy-align
      executor-nvim
      vim-markdown # Not nvim-markdown but suffices for now
      nvim-surround
      telescope-symbols-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "silicon-lua";
        src = pkgs.fetchFromGitHub {
          owner = "0oAstro";
          repo = "silicon.lua";
          rev = "8db5682";
          hash = "sha256-W/EaQtatNaEtuO9qHkjND54jtA8UKN8Jd9W5zFOhiAQ=";
        };
      })
      (pkgs.silicon)
    ];

    extraConfigLuaPost = ''
      require("executor").setup({})
      require("nvim-surround").setup({})

      vim.g.vim_markdown_conceal = 0

      require("silicon").setup({
      	theme = "dark",
      	font = "JetBrainsMono Nerd Font",
      	lineNumber = true,
      	padHoriz = 60, -- Horizontal padding
      	padVert = 40, -- vertical padding
      	shadowBlurRadius = 0,
      	windowControls = false,
      })
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


      {
        mode = "v";
        key = "<leader>sc";
        action = ":lua require'silicon'.visualise_api{to_clip = true } <CR>";
        options = {
          desc = "Take a silicon code snippet into the clipboard";
        };
      }
      {
        mode = "v";
        key = "<leader>ss";
        action = ":lua require'silicon'.visualise_api{}<CR>";
        options = {
          desc = "Take a silicon code snippet";
        };
      }
    ];
  };
}
