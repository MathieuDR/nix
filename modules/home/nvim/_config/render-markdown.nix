{
  config.plugins.render-markdown = {
    enable = true;
    settings = {
      latex.enabled = false;
      checkbox.custom = {
        todo.raw = "[todo]";

        important = {
          raw = "[!]";
          rendered = "󱈸 ";
          highlight = "Markdown.Important.icon";
          scope_highlight = "Markdown.Important.scope";
        };

        progress = {
          raw = "[/]";
          rendered = "󱍷 ";
          highlight = "Markdown.InProgress";
          scope_highlight = "Markdown.InProgress";
        };

        rescheduled = {
          raw = "[>]";
          rendered = "󰃰 ";
          highlight = "Markdown.Rescheduled";
          scope_highlight = "Markdown.Rescheduled";
        };

        cancelled = {
          raw = "[-]";
          rendered = " ";
          highlight = "Markdown.Cancelled";
          scope_highlight = "Markdown.Cancelled";
        };

        question = {
          raw = "[?]";
          rendered = " ";
          highlight = "Markdown.Question";
          scope_highlight = "Markdown.Question";
        };
      };
    };
  };

  config.highlight = {
    "Markdown.InProgress" = {
      fg = "#cba6f7";
    };

    "Markdown.Question" = {
      fg = "#f9e2af";
    };

    "Markdown.Cancelled" = {
      fg = "#eba0ac";
      strikethrough = true;
    };

    "Markdown.Rescheduled" = {
      fg = "#f5c2e7";
      strikethrough = true;
    };

    "Markdown.Important.scope" = {
      fg = "#f38ba8";
      bold = true;
      underdouble = true;
    };

    "Markdown.Important.icon" = {
      bg = "#f38ba8";
      fg = "#1e1e2e";
      bold = true;
      underdouble = true;
    };
  };

  config.keymaps = [
  ];
}
