{
  config.plugins = {
    comment-nvim.enable = true;
    todo-comments = {
      enable = true;
      keywords = {
        FIX = {
          icon = " ";
          color = "error";
          alt = [ "FIXME" "BUG" "fixme" "fixdocs" "ISSUE" ];
        };
      };
    };
  };
}
