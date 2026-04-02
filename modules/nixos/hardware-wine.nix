{...}: {
  flake.modules.nixos.hardware-wine = {
    # 32-bit support for Wine/Proton (also set by hardware-amd, but explicit here)
    hardware.graphics.enable32Bit = true;
  };
}
