{
  config.plugins = {
    web-devicons.enable = true;
    trouble.enable = true;
  };

  config.keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>";
      options = {
        desc = "[T]rouble [T]oggle Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>td";
      action = "<cmd>Trouble symbols toggle<CR>";
      options = {
        desc = "[T]rouble [D]ocument Symbols";
      };
    }
    # {
    #   mode = "n";
    #   key = "<leader>tf";
    #   action = "<cmd>Trouble fuzzy toggle<CR>";
    #   options = {
    #     desc = "[T]rouble Tele[S]cope";
    #   };
    # }
    # {
    #   mode = "n";
    #   key = "<leader>ts";
    #   action = "<cmd>Trouble telescope toggle<CR>";
    #   options = {
    #     desc = "[T]rouble Tele[S]cope";
    #   };
    # }
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>Trouble lsp toggle focus=false filter.buf=0<CR>";
      options = {
        desc = "[T]rouble Lsp, current buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action = "<cmd>Trouble lsp toggle focus=false<CR>";
      options = {
        desc = "[T]rouble [L]sp";
      };
    }
    {
      mode = "n";
      key = "<leader>tq";
      action = "<cmd>Trouble qflist toggle focus=false<CR>";
      options = {
        desc = "[T]rouble [Q]uickfix";
      };
    }
  ];
}
