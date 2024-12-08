{...}: {
  services.tlp = {
    enable = true;
    settings = {
      # Battery charge thresholds for longer battery lifespan
      START_CHARGE_THRESH_BAT0 = 60;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # CPU Power Management
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Storage/Disk Power Management
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
      DISK_IOSCHED = "none"; # Let the SSD handle scheduling

      # PCIe Device Power Management (GPU, WiFi, etc)
      # Still allow some power management on AC to reduce heat
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # WiFi Power Management
      # Full power on AC, power saving on battery
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # USB Power Management
      # Enable autosuspend but with a longer timeout on AC
      USB_AUTOSUSPEND = 1;
      USB_AUTOSUSPEND_DELAY_ON_AC = 10; # 10 second delay when on AC
      USB_AUTOSUSPEND_DELAY_ON_BAT = 2; # 2 second delay when on battery
    };
  };

  # Enable and configure UPower for system-wide power monitoring
  # Ignoring UPower's battery percentage limits since TLP handles them
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 10;
    percentageAction = 5;
    criticalPowerAction = "Hibernate";
  };

  # Enable thermald for better temperature management
  services.thermald.enable = true;

  # Power consumption analysis + auto-tuning on startup
  powerManagement.powertop.enable = true;
  services.acpid.enable = true;
}
