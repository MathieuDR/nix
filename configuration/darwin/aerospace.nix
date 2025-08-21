{...}: {
  _file = ./aerospace.nix;
  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        outer.left = 2;
        outer.bottom = 2;
        outer.top = 2;
        outer.right = 2;
      };

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      on-focus-changed = ["move-mouse window-lazy-center"];

      mode.main.binding = {
        alt-h = "focus --boundaries-action wrap-around-the-workspace --boundaries all-monitors-outer-frame left";
        alt-j = "focus --boundaries-action wrap-around-the-workspace --boundaries all-monitors-outer-frame down";
        alt-k = "focus --boundaries-action wrap-around-the-workspace --boundaries all-monitors-outer-frame up";
        alt-l = "focus --boundaries-action wrap-around-the-workspace --boundaries all-monitors-outer-frame right";

        alt-t = ''
          exec-and-forget osascript -e '
          tell application "kitty"
            do script
            activate
          end tell'
        '';

        alt-ctrl-h = "swap left --wrap-around";
        alt-ctrl-j = "swap down --wrap-around";
        alt-ctrl-k = "swap up --wrap-around";
        alt-ctrl-l = "swap right --wrap-around";

        alt-shift-h = "move --boundaries all-monitors-outer-frame left";
        alt-shift-j = "move --boundaries all-monitors-outer-frame down";
        alt-shift-k = "move --boundaries all-monitors-outer-frame up";
        alt-shift-l = "move --boundaries all-monitors-outer-frame right";

        shift-cmd-up = "move-node-to-workspace next --wrap-around --focus-follows-window";
        shift-cmd-down = "move-node-to-workspace prev --wrap-around --focus-follows-window";

        ctrl-cmd-up = "workspace next --wrap-around";
        ctrl-cmd-down = "workspace prev --wrap-around";

        alt-e = "fullscreen";
        alt-s = "join-with right";
      };

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "secondary";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
        "10" = "secondary";
      };
    };
  };
}
