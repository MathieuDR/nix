{...}: {
  programs.imv = {
    enable = true;
    settings = {
      #options.background = "ffffff";
      #aliases.x = "close";

      options = {
        overlay = true;
        overlay_font = "JetBrains Mono:12";
        overlay_text = "$imv_current_file [$imv_width x $imv_height] $imv_scale%";
      };

      binds = {
        j = "next";
        k = "prev";

        d = "exec rm '$imv_current_file'; close";
      };
    };
  };
}
