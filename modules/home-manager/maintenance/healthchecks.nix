{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.maintenance.healthchecks;

  healthCheckScript = pkgs.writeShellScript "healthcheck" ''
    set -e

    check_host() {
      local addr="$1"
      local max_retries=${toString cfg.retries}
      local delay=${toString cfg.retryDelay}

      for ((i=1; i<=max_retries; i++)); do
        if ${pkgs.iputils}/bin/ping -c 1 -W 2 "$addr" > /dev/null 2>&1; then
          return 0
        fi
        echo "[$addr] check $i/$max_retries failed"
        if [ $i -lt $max_retries ]; then
          sleep $delay
          delay=$((delay * 2))
        fi
      done
      return 1
    }

    failed_hosts=""
    ${concatMapStringsSep "\n" (addr: ''
        if ! check_host "${addr}"; then
          failed_hosts="$failed_hosts - ${addr}\n"
        fi
      '')
      cfg.addresses}

    if [ -n "$failed_hosts" ]; then
      ${optionalString cfg.notifications.enable ''
      message="Failed to reach:\n$failed_hosts"
      ${pkgs.dunst}/bin/dunstify -u critical "Health Check Failed" "$message"
    ''}
      exit 1
    fi
  '';
in {
  options.maintenance.healthchecks = {
    enable = mkEnableOption "health check monitoring for servers";

    addresses = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["firesprout.home.deraedt.dev" "hpi.home.deraedt.dev" "deraedt.dev"];
      description = "List of IP addresses or domains to monitor";
    };

    notifications = {
      enable = mkEnableOption "desktop notifications for failed health checks";
    };

    interval = mkOption {
      type = types.str;
      default = "5min";
      example = "5min";
      description = "How often to run health checks (systemd time format)";
    };

    retries = mkOption {
      type = types.int;
      default = 3;
      example = 5;
      description = "Number of attempts before marking a host as failed";
    };

    retryDelay = mkOption {
      type = types.int;
      default = 2;
      example = 5;
      description = "Initial delay between retries in seconds (doubles each attempt)";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.healthcheck = {
      Unit = {
        Description = "Health check monitoring service";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${healthCheckScript}";
        Environment = ["DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus"];
        RemainAfterExit = false;
      };
    };

    systemd.user.timers.healthcheck = {
      Unit = {
        Description = "Timer for health check monitoring";
      };

      Timer = {
        OnBootSec = "1min";
        OnUnitInactiveSec = cfg.interval;
        Unit = "healthcheck.service";
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
