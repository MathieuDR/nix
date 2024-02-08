{
  config.plugins = {
    oil.enable = true;
    neo-tree = {
      enable = true;
      eventHandlers = {
        file_opened = ''
          				function()
          					vim.cmd.NeoTree("close")
          				end
          			'';
      };
    };
  };
}
