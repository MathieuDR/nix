{
  pkgs,
  user,
  ...
}: let
  scriptName = "set-laptop-monitor";
  monitorScript = pkgs.writeShellScriptBin "set-laptop-monitor" ''
    #!/usr/bin/env bash
    # Try to find Hyprland signature if not set
    if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        SIGNATURE=$(ls -1 "$XDG_RUNTIME_DIR/hypr" | grep 'hyprland-' | head -n1)
        if [ -n "$SIGNATURE" ]; then
            export HYPRLAND_INSTANCE_SIGNATURE="$SIGNATURE"
        fi
    fi

    # Check if we found the signature and socket exists
    if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ] || [ ! -e "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock" ]; then
        echo "Hyprland socket not found, exiting with error"
        echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
        echo "HYPRLAND_INSTANCE_SIGNATURE: $HYPRLAND_INSTANCE_SIGNATURE"
        exit 1
    fi

    if hyprctl monitors | grep -q "AOC 2778X" && hyprctl monitors | grep -q "MAG274QRF-QD"; then
        hyprctl keyword monitor "eDP-1,disable"
    else
        hyprctl keyword monitor "eDP-1,1920x1200@60,0x0,1"
    fi
  '';
in {
  home.packages = [
    monitorScript
  ];

  # services.udev.extraRules = ''
  #   ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.bash}/bin/bash -c 'exec ${pkgs.systemd}/bin/systemctl start --no-block ${scriptName}.service'"
  # '';

  systemd.user.services.${scriptName} = {
    Unit = {
      Description = "Handle laptop screen based on docked monitors";
      PartOf = ["hyprland-session.target"];
      # Requires = ["hyprland-session.target"];
      After = ["hyprland-session.target"];
    };

    Service = {
      ExecStart = "${monitorScript}/bin/${scriptName}";
      Type = "oneshot";
      Environment = [
        "XDG_RUNTIME_DIR=/run/user/%U"
        "HYPRLAND_INSTANCE_SIGNATURE=%E{HYPRLAND_INSTANCE_SIGNATURE}"
        "WAYLAND_DISPLAY=%E{WAYLAND_DISPLAY}"
      ];

      # Restart settings
      Restart = "on-failure";
      RestartSec = "1s";
      # Stop trying after 5 failures
      StartLimitBurst = 5;
      StartLimitIntervalSec = 10;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mainMod, m, exec, ${scriptName}"
      ];
      monitor = [
        # Laptop screen - enabled by default but disabled if dock monitors connected
        "eDP-1, 1920x1200@60, 0x0, 1"

        # Your dock monitors - these rules need to come after eDP-1
        "desc:AOC 2778X, 2560x1440@60, 1920x0, 1"
        "desc:Microstep MAG274QRF-QD, 2560x1440@60, 4480x0, 1"

        # Fallback rule for any other monitors
        ", preferred, auto, 1"
      ];
    };
  };
}
