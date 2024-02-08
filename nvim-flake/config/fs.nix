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
  config.keymaps = [
    {
      mode = "n";
      key = "-";
      action = ":Neotree reveal toggle=true position=current<CR>";
      options = {
        desc = "Toggle Neotree";
      };
    }
  ];
}
