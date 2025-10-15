{
  inputs,
  user,
  ...
}: {
  # Host-specific Darwin configuration
  environment.systemPackages = [
    inputs.home-manager.packages.aarch64-darwin.default
  ];

  system = {
    primaryUser = user;
    startup.chime = false;

    defaults = {
      ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleTemperatureUnit = "Celsius";
        NSDocumentSaveNewDocumentsToCloud = false;
        NSTableViewDefaultSizeMode = 1;
        "com.apple.springing.enabled" = false;
        "com.apple.swipescrolldirection" = false;
      };
      WindowManager.GloballyEnabled = false;
      dock.autohide = true;
      finder = {
        ShowPathbar = true;
        ShowExternalHardDrivesOnDesktop = false;
        FXRemoveOldTrashItems = true;
        FXPreferredViewStyle = "Nlsv";
        CreateDesktop = false;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };

      loginwindow.GuestEnabled = false;
      screencapture.target = "clipboard";
    };

    keyboard = {
      enableKeyMapping = false;
    };
  };

  # Feels risky
  # users = {
  #   # knownUsers = [user];
  #
  #   users."${user}" = {
  #     shell = pkgs.fish;
  #   };
  # };
}
