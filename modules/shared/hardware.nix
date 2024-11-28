{lib, ...}:
with lib; {
  options.ysomic.hardware.nvidia = {
    enable = mkEnableOption "Nvidia hardware";
    card = mkOption {
      default = "1080ti";
      description = "The card used";
      type = types.enum ["1080ti"];
    };
  };
}
