{...}: {
  flake.modules.nixos.sound = {
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [48000];
          # Calculation: quantum / clock_rate * 1000 = delay in ms
          "default.clock.min-quantum" = 512;
          "default.clock.quantum" = 800;
          "default.clock.max-quantum" = 1024;
        };
      };
    };
  };
}
