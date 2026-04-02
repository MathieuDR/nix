{
  config.plugins = {
    comment.enable = true;
    todo-comments = {
      enable = true;
      settings.keywords = {
        FIX = {
          icon = " ";
          color = "error";
          alt = ["FIXME" "BUG" "fixme" "fixdocs" "ISSUE"];
        };
      };
    };
  };

  config.keymaps = [
    {
      mode = "n";
      key = "]t";
      action.__raw = ''
        function()
        	require("todo-comments").jump_next()
        end
      '';
      options = {
        desc = "Next todo comment";
      };
    }
    {
      mode = "n";
      key = "[t";
      action.__raw = ''
        function()
        	require("todo-comments").jump_prev()
        end
      '';
      options = {
        desc = "Previous todo comment";
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = ":TodoTrouble<CR>";
      options = {
        desc = "[T]rouble [C]omments";
      };
    }
    {
      mode = "n";
      key = "<leader>sn";
      action = ":TodoTelescope keywords=FIXME,FIX,fixme,fixdocs,BUG<CR>";
      options = {
        desc = "Tele[S]cope FixMe [N]otes";
      };
    }
    {
      mode = "n";
      key = "<leader>sc";
      action = ":TodoTelescope<CR>";
      options = {
        desc = "Tele[S]cope [C]omments";
      };
    }
  ];
}
