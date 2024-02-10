{
  config.plugins = {
    nvim-ufo = {
      enable = true;
      providerSelector = ''
        function(bufnr, filetype, buftype)
        	return { 'lsp', 'indent' }
        end
      '';
    };
  };
}
