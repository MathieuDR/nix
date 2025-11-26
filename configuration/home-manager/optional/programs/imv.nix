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

        # Mark for deletion (adds DEL_ prefix)
        d = "exec mv \"$imv_current_file\" \"$(dirname \"$imv_current_file\")/DEL_$(basename \"$imv_current_file\")\"; close";
        s = "exec mv \"$imv_current_file\" \"$(dirname \"$imv_current_file\")/SELECTED_$(basename \"$imv_current_file\")\"; close";
      };
    };
  };
}
