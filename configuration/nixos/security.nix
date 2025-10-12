{
  pkgs,
  self,
  hostname,
  ...
}: {
  # local caddy certificate
  security.pki.certificates = [
    # HPI Certificate
    (builtins.readFile "${self}/data/secrets/certificates/hpi_ca.crt")
  ];

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

  # GNOME keyring service (gcr = GNOME Crypto), needed for pinentry.gnome3
  services.dbus.packages = [pkgs.gcr];

  age.identityPaths = ["/etc/${hostname}/agenix_${hostname}_system"];
}
