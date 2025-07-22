{pkgs, ...}: {
  boot.kernelModules = ["thinkpad_acpi"];
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1 experimental=1
  '';

  services.thinkfan = {
    enable = false;

    # sensors = [
    #   {
    #     type = "hwmon";
    #     query = "/sys/class/hwmon/hwmon5/temp1_input"; # CPU temperature
    #   }
    #   {
    #     type = "hwmon";
    #     query = "/sys/class/hwmon/hwmon5/temp3_input"; # Additional sensor
    #   }
    #   {
    #     type = "hwmon";
    #     query = "/sys/class/hwmon/hwmon7/temp1_input"; # GPU temperature (amdgpu)
    #   }
    # ];

    # Balanced fan curve
    levels = [
      [0 0 45] # Fan off below 45°C
      [1 40 50] # Level 1 between 40-50°C
      [2 45 55] # Level 2 between 45-55°C
      [3 50 60] # Level 3 between 50-60°C
      [4 55 65] # Level 4 between 55-65°C
      [5 60 75] # Level 5 between 60-75°C
      [6 65 80] # Level 6 between 65-80°C
      [7 75 32767] # Maximum fan speed above 75°C
    ];

    extraArgs = ["-v"];
  };

  systemd.services.thinkfan.preStart = "
    /run/current-system/sw/bin/modprobe  -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi
  ";

  environment.systemPackages = with pkgs; [
    lm_sensors
    thinkfan
  ];
}
