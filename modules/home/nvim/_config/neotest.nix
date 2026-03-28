{
  config = {
    plugins = {
      neotest = {
        enable = true;
        adapters = {
          elixir.enable = true;
        };
        settings = {
          output = {
            enabled = true;
            open_on_run = true;
          };
          output_panel = {
            enabled = true;
            open = "botright split | resize 15";
          };
          summary = {
            enabled = true;
            animated = true;
            follow = true;
            expand_errors = true;
          };
        };
      };
    };

    extraConfigLuaPost = ''
      -- Function to run mix test.next
      local function run_mix_test_next()
        require('neotest').run.run({
          extra_args = { '--failed', '--max-failures=1', '--seed=0' }
        })
      end

      -- Make it available globally
      vim.api.nvim_create_user_command('TestNext', run_mix_test_next, {})
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>ta";
        action.__raw = "function() require('neotest').run.run(vim.fn.getcwd()) end";
        options = {
          desc = "[T]est [A]ll";
        };
      }

      {
        mode = "n";
        key = "<leader>tn";
        action.__raw = "function() require('neotest').run.run() end";
        options = {
          desc = "[T]est [N]earest";
        };
      }
      {
        mode = "n";
        key = "<leader>tf";
        action.__raw = "function() require('neotest').run.run(vim.fn.expand('%')) end";
        options = {
          desc = "[T]est [F]ile";
        };
      }
      {
        mode = "n";
        key = "<leader>to";
        action.__raw = "function() require('neotest').output.open() end";
        options = {
          desc = "[T]est [O]utput";
        };
      }
      {
        mode = "n";
        key = "<leader>ts";
        action.__raw = "function() require('neotest').summary.toggle() end";
        options = {
          desc = "[T]est [S]ummary";
        };
      }

      {
        mode = "n";
        key = "<leader>tN";
        action = ":TestNext<CR>";
        options = {
          desc = "[T]est [N]ext Failed";
        };
      }
    ];
  };
}
