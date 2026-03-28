{inputs, ...}: {
  flake.modules.nixos.security = {
    pkgs,
    config,
    ...
  }: {
    security.pki.certificates = [
      (builtins.readFile "${inputs.self}/data/secrets/certificates/hpi_ca.crt")
      (builtins.readFile "${inputs.self}/data/secrets/certificates/firesprout.crt")
    ];

    # GNOME keyring for pinentry
    services.dbus.packages = [pkgs.gcr];
    services.gnome.gnome-keyring.enable = true;

    # Polkit for privilege escalation dialogs
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Agenix identity path uses networking.hostName
    age.identityPaths = ["/etc/${config.networking.hostName}/agenix_${config.networking.hostName}_system"];

    environment.systemPackages = [pkgs.clamav];
    services.clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };
}
