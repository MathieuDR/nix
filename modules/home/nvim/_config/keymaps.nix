{
  config.keymaps = [
    {
      mode = ["n" "v"];
      key = "<space>";
      action = "<Nop>";
      options = {
        silent = true;
      };
    }
    {
      mode = ["n" "v"];
      key = "<leader>cs";
      action = ":noh<CR>";
      options = {
        silent = true;
        desc = "[C]lear [S]earch";
      };
    }
    {
      mode = "n";
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        silent = true;
        expr = true;
      };
    }
    {
      mode = "n";
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        silent = true;
        expr = true;
      };
    }

    {
      mode = "n";
      key = "<c-w>d";
      action = ":bp|bd #<CR>";
      options = {
        desc = "Delete buffer without closing split";
        silent = true;
        noremap = true;
      };
    }
  ];
}
