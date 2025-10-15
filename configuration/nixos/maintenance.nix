{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nvme-cli
  ];

  systemd.services.nvme-health-check = {
    description = "Check NVMe drive health status";
    serviceConfig = {
      Type = "oneshot";
      # Run as root to access nvme devices
      User = "root";
      # Don't restart on failure - we want it to stay failed as an alert
      Restart = "no";
    };

    script = ''
      set -euo pipefail

      NVME_DEVICES=$(${pkgs.nvme-cli}/bin/nvme list -o json | ${pkgs.jq}/bin/jq -r '.Devices[].DevicePath')

      if [ -z "$NVME_DEVICES" ]; then
        echo "No NVMe devices found"
        exit 0
      fi

      UNHEALTHY_FOUND=0

      for device in $NVME_DEVICES; do
        echo "Checking $device..."
        SMART_OUTPUT=$(${pkgs.nvme-cli}/bin/nvme smart-log "$device" -o json)

        # Extract critical fields
        CRITICAL_WARNING=$(echo "$SMART_OUTPUT" | ${pkgs.jq}/bin/jq -r '.critical_warning')
        AVAIL_SPARE=$(echo "$SMART_OUTPUT" | ${pkgs.jq}/bin/jq -r '.avail_spare')
        SPARE_THRESH=$(echo "$SMART_OUTPUT" | ${pkgs.jq}/bin/jq -r '.spare_thresh')
        PERCENT_USED=$(echo "$SMART_OUTPUT" | ${pkgs.jq}/bin/jq -r '.percent_used')
        MEDIA_ERRORS=$(echo "$SMART_OUTPUT" | ${pkgs.jq}/bin/jq -r '.media_errors')

        echo "  Critical Warning: $CRITICAL_WARNING"
        echo "  Available Spare: $AVAIL_SPARE% (threshold: $SPARE_THRESH%)"
        echo "  Percentage Used: $PERCENT_USED%"
        echo "  Media Errors: $MEDIA_ERRORS"

        if [ "$CRITICAL_WARNING" != "0" ]; then
          echo "ERROR: $device has critical warning flag set!"
          UNHEALTHY_FOUND=1
        fi

        if [ "$AVAIL_SPARE" -lt "$SPARE_THRESH" ]; then
          echo "ERROR: $device available spare ($AVAIL_SPARE%) below threshold ($SPARE_THRESH%)!"
          UNHEALTHY_FOUND=1
        fi

        if [ "$PERCENT_USED" -gt "90" ]; then
          echo "WARNING: $device is $PERCENT_USED% used (>90%)"
          UNHEALTHY_FOUND=1
        fi

        if [ "$MEDIA_ERRORS" != "0" ]; then
          echo "ERROR: $device has $MEDIA_ERRORS media errors!"
          UNHEALTHY_FOUND=1
        fi
      done

      if [ "$UNHEALTHY_FOUND" -eq 1 ]; then
        echo "One or more NVMe drives are unhealthy!"
        exit 1
      fi

      echo "All NVMe drives are healthy"
    '';
  };

  systemd.timers.nvme-health-check = {
    description = "Timer for NVMe health checks";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5min"; # 5min after boot
      OnUnitActiveSec = "12h"; # every 12h
      Persistent = true;
    };
  };
}
