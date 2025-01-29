{
  config,
  pkgs,
  ...
}: let
  setup-discord-settings = pkgs.writeShellScriptBin "setup-discord-settings" ''
    DISCORD_CONFIG="${config.xdg.configHome}/discord"
    SETTINGS_FILE="$DISCORD_CONFIG/settings.json"

    echo "Setting up Discord config..."
    echo "Config path: $DISCORD_CONFIG"

    # Create directory if it doesn't exist
    mkdir -p "$DISCORD_CONFIG"

    if [ ! -f "$SETTINGS_FILE" ] || [ ! -s "$SETTINGS_FILE" ]; then
      echo "Creating new Discord settings file..."
      echo '{"SKIP_HOST_UPDATE": true}' > "$SETTINGS_FILE"
      echo "Created with content: $(cat "$SETTINGS_FILE" || echo "<empty file>")"
    else
      echo "Updating Discord settings..."
      echo "Current content: $(cat "$SETTINGS_FILE" || echo "<empty file>")"
      ${pkgs.jq}/bin/jq '. + {"SKIP_HOST_UPDATE": true}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
      mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
      echo "New content: $(cat "$SETTINGS_FILE" || echo "<empty file>")"
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

    Install = {
      WantedBy = ["basic.target"];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${setup-discord-settings}/bin/setup-discord-settings";
    };
  };
}
