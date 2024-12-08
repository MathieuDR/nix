{lib, ...}: let
  usbDevices = [
    {
      name = "USB Switch";
      vendor = "05e3";
      product = "0610";
    }
    {
      name = "Moonlander keyboard";
      vendor = "3297";
      product = "1969";
    }
    {
      name = "Xtrify M42";
      vendor = "2ea8";
      product = "2203";
    }
  ];

  formatTlpDeviceId = device: "${device.vendor}:${device.product}";

  makeUdevRule = device: ''
    # ${device.name}
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="${device.vendor}", ATTRS{idProduct}=="${device.product}", ATTR{power/wakeup}="enabled"
  '';
in {
  # Configure TLP to deny power management for our devices
  services.tlp.settings = {
    # Join all device IDs with spaces between them
    USB_DENYLIST = lib.concatStringsSep " " (map formatTlpDeviceId usbDevices);
  };

  # Generate udev rules for all devices
  services.udev.extraRules =
    # Concatenate all rules with newlines between them
    lib.concatStringsSep "\n" (map makeUdevRule usbDevices);
}
