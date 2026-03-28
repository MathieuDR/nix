{
  config.plugins = {
    nvim-ufo = {
      enable = true;
      settings.provider_selector = ''
        function(bufnr, filetype, buftype)
        	return { 'lsp', 'indent' }
        end
      '';
    };
  };

  config.opts = {
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };

  config.keymaps = [
    {
      mode = "n";
      key = "zR";
      action.__raw = "require('ufo').openAllFolds";
      options = {
        desc = "Fold [R]eveal all";
      };
    }
    {
      mode = "n";
      key = "zM";
      action.__raw = "require('ufo').closeAllFolds";
      options = {
        desc = "Fold Close all";
      };
    }
  ];
}
