{...}: {
  flake.modules.nixos.hardware-amd = {pkgs, ...}: {
    # https://wiki.nixos.org/wiki/AMD_GPU
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load amdgpu driver before boot (needed so Hyprland doesn't crash)
    boot.initrd.kernelModules = ["amdgpu"];

    systemd.packages = with pkgs; [
      lact
      amdgpu_top
      mesa-demos
    ];

    # LACT for overclocking, undervolting, fan curves
    environment.systemPackages = [pkgs.lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
  };
}
