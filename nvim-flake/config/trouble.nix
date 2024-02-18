{
  config.plugins = {
    trouble = {
      icons = true;
      enable = true;
      signs = {
        error = "";
        warning = "";
        hint = "";
        information = "";
        other = "";
      };
    };
  };

  config.keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>TroubleToggle<CR>";
      options = {
        desc = "[T]rouble [T]oggle";
      };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = "<cmd>TroubleRefresh<CR>";
      options = {
        desc = "[T]rouble [R]efresh";
      };
    }
    {
      mode = "n";
      key = "<leader>tw";
      action.__raw = "function() require('trouble').toggle('workspace_diagnostic') end";
      options = {
        desc = "[T]rouble [W]orkspace diagnostic";
      };
    }
    {
      mode = "n";
      key = "<leader>td";
      action.__raw = "function() require('trouble').toggle('document_diagnostics') end";
      options = {
        desc = "[T]rouble [D]ocument diagnostic";
      };
    }
    {
      mode = "n";
      key = "<leader>tq";
      action.__raw = "function() require('trouble').toggle('quickfix') end";
      options = {
        desc = "[T]rouble [Q]uickfix";
      };
    }
    {
      mode = "n";
      key = "<leader>tL";
      action.__raw = "function() require('trouble').toggle('loclist') end";
      options = {
        desc = "[T]rouble [L]ocallist";
      };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action.__raw = "function() require('trouble').toggle('lsp_references') end";
      options = {
        desc = "[T]rouble [L]sp references";
      };
    }
    {
      mode = "n";
      key = "<leader>tn";
      action.__raw = "function() require('trouble').next({skip_groups = true, jump = true}) end";
      options = {
        desc = "[T]rouble [N]ext";
      };
    }
    {
      mode = "n";
      key = "<leader>tp";
      action.__raw = "function() require('trouble').previous({skip_groups = true, jump = true}) end";
      options = {
        desc = "[T]rouble [N]ext";
      };
    }
  ];
}
