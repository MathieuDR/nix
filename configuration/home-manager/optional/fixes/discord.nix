{
  config,
  pkgs,
  lib,
  ...
}: {
  home.activation.setupDiscordSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    verboseEcho "Setting up Discord config..."
    verboseEcho "Config path: ${config.xdg.configHome}/discord"

    DISCORD_CONFIG="${config.xdg.configHome}/discord"
    SETTINGS_FILE="$DISCORD_CONFIG/settings.json"

    run mkdir -p "$DISCORD_CONFIG"

    if [ ! -f "$SETTINGS_FILE" ] || [ ! -s "$SETTINGS_FILE" ]; then
      verboseEcho "Creating new Discord settings file..."
      run echo '{"SKIP_HOST_UPDATE": true}' > "$SETTINGS_FILE"
      verboseEcho "$(cat "$SETTINGS_FILE" || echo "<empty file>")"
    else
      verboseEcho "Updating Discord settings..."
      verboseEcho "Current content:"
      verboseEcho "$(cat "$SETTINGS_FILE" || echo "<empty file>")"
      ${pkgs.jq}/bin/jq '. + {"SKIP_HOST_UPDATE": true}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
      run mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
      verboseEcho "New content:"
      verboseEcho "$(cat "$SETTINGS_FILE" || echo "<empty file>")"
    fi
  '';
}
