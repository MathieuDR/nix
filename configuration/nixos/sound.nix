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
  };
}
