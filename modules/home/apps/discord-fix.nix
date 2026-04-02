{...}: {
  flake.modules.homeManager.discord-fix = {
    pkgs,
    config,
    ...
  }: let
    setup-discord-settings = pkgs.writeShellScriptBin "setup-discord-settings" ''
      DISCORD_CONFIG="${config.xdg.configHome}/discord"
      SETTINGS_FILE="$DISCORD_CONFIG/settings.json"

      echo "Setting up Discord config..."
      mkdir -p "$DISCORD_CONFIG"

      if [ ! -f "$SETTINGS_FILE" ] || [ ! -s "$SETTINGS_FILE" ]; then
        echo '{"SKIP_HOST_UPDATE": true}' > "$SETTINGS_FILE"
      else
        ${pkgs.jq}/bin/jq '. + {"SKIP_HOST_UPDATE": true}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
        mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
      fi
    '';
  in {
    home.packages = [setup-discord-settings];

    systemd.user.services.discord-settings = {
      Unit = {
        Description = "Setup Discord Settings";
        After = ["basic.target"];
        Before = ["graphical-session.target"];
      };

      Install.WantedBy = ["basic.target"];

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${setup-discord-settings}/bin/setup-discord-settings";
      };
    };
  };
}
