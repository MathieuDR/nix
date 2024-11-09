{self, ...}: {
  # local caddy certificate
  security.pki.certificates = [
    # HPI Certificate
    (builtins.readFile "${self}/secrets/hpi_ca.crt")
  ];
}
