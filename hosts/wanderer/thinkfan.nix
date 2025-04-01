{pkgs, ...}: {
  # Load the thinkpad_acpi module with fan control enabled
  boot.kernelModules = ["thinkpad_acpi"];
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  # Enable thinkfan service
  services.thinkfan = {
    enable = true;
    sensors = ''
      hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon*/temp1_input
    '';

    # LEVEL, LOW, HIGH
    levels = [
      [0 0 55]
      [1 48 60]
      [2 55 65]
      [3 60 70]
      [4 65 75]
      [5 70 82]
      [6 75 85]
      [7 82 32767]
    ];
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    thinkfan
  ];
}
