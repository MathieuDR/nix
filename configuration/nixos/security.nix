{
  pkgs,
  self,
  ...
}: {
  # local caddy certificate
  security.pki.certificates = [
    # HPI Certificate
    (builtins.readFile "${self}/data/secrets/hpi_ca.crt")
  ];

  programs.gnupg = {
    dirmngr.enable = true;
    agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
}
