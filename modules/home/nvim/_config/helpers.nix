{
  config = {
    # HIGHLIGHT ON YANK
    autoGroups = {
      yanked_text = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = "TextYankPost";
        pattern = "*";
        callback = {
          __raw = ''
            function()
            	vim.highlight.on_yank()
            end
          '';
        };
        group = "yanked_text";
      }
    ];
  };
}
