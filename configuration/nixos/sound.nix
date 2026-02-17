{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # media-session.enable = false;

    #Extra config if needed
    # https://wiki.nixos.org/wiki/PipeWire#Bluetooth_Configuration
    # https://wiki.archlinux.org/title/bluetooth_headset#Disable_PipeWire_HSP/HFP_profile
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [48000];
        # Calculation: qantum / clock_rate * 1000 = dealy in ms
        # Going for sub 60Hz means delay should be <16ms
        "default.clock.min-quantum" = 512;
        "default.clock.quantum" = 800;
        "default.clock.max-quantum" = 1024;
      };
    };
  };
}
