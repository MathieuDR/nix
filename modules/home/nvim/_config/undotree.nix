{
  config.plugins.undotree.enable = true;
  config.keymaps = [
    {
      mode = "n";
      key = "<leader>tu";
      action = ":UndotreeToggle<CR>";
      options.desc = "[T]oggle [U]ndotree";
    }
  ];
}
