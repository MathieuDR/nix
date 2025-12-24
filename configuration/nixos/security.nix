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
    # Firesfrout
    (builtins.readFile "${self}/data/secrets/certificates/firesprout.crt")
  ];

  # GNOME keyring service (gcr = GNOME Crypto), needed for pinentry.gnome3
  services.dbus.packages = [pkgs.gcr];

  # Polkit, basically asks for passwords on privilege escalation
  # Eg popsicle, 1 password etc.
  security.polkit.enable = true;

  # Creating agent for polkit
  # https://wiki.nixos.org/wiki/Polkit
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

  age.identityPaths = ["/etc/${hostname}/agenix_${hostname}_system"];

  environment.systemPackages = [
    pkgs.clamav
  ];

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };
}
