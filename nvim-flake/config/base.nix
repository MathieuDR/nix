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
  };
}
