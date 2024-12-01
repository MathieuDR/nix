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

  # GNOME keyring service (gcr = GNOME Crypto), needed for pinentry.gnome3
  services.dbus.packages = [pkgs.gcr];

  age.identityPaths = ["/etc/${hostname}/agenix_${hostname}_system"];
}
