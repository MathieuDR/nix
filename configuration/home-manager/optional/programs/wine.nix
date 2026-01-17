{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bottles
    winetricks
  ];

  hardware.opengl.driSupport32Bit = true;
}
